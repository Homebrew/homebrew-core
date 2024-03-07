class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://github.com/moonrepo/moon/archive/refs/tags/v1.22.5.tar.gz"
  sha256 "9381c3f1157aa04db6fb4d8e938eb283fb6dd60559c448badc2afa17f5368827"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bb82af2e6b7bcd558a2e7324c2cb3c62b884ad73f71b40db557ef5f296b0779f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3b7fc4541bcc297b4927ec92af53e9323f04930df29873073a62bd8c8b1d6600"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cdc39bc5e4c50f531cac0cb9621ff7a4a079d63e034eb4bf9d6768246cedc919"
    sha256 cellar: :any_skip_relocation, sonoma:         "4581695cb5765644327779731638d294465f1eb404ab775f405cba638ff5cbb2"
    sha256 cellar: :any_skip_relocation, ventura:        "49420eebeae0bf696bab44cc6fe3aa9082f7f26364ecd43a7e5967ff901f3827"
    sha256 cellar: :any_skip_relocation, monterey:       "a3399a18593e0ccbe00fb5195512fd05ab382babc55524b02294eda82da5f105"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96e7c74aa0f4b376c580c59c6ed4299453ba31ff52c787f0faf3d39bab2107b9"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
    depends_on "xz"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
    generate_completions_from_executable(bin/"moon", "completions", "--shell")

    bin.each_child do |f|
      basename = f.basename

      (libexec/"bin").install f
      (bin/basename).write_env_script libexec/"bin"/basename, MOON_INSTALL_DIR: opt_prefix/"bin"
    end
  end

  test do
    system bin/"moon", "init", "--minimal", "--yes"
    assert_predicate testpath/".moon"/"workspace.yml", :exist?
  end
end
