class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://github.com/moonrepo/moon/archive/refs/tags/v1.27.6.tar.gz"
  sha256 "e2f88f4af9534092692a09c49f4dd6d8d96535df7134f4f5c66c0aee3df57673"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c4dd39b03ed2f35371fe711971d76a3607c0e21b37d76a31060a6a976c20160b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "49aa383655dbf783ea3e4fc835999c3974b7f3789c8f6ec0f573e7eaf7371fc6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54cc89e082c1e318eddf0dfc957c053dfc542d2ed9562f66d16b111ce8394283"
    sha256 cellar: :any_skip_relocation, sonoma:         "0c12e800c67731a85b5ce540ae54a21ea83b7560cb71ef33436d69ae6640064d"
    sha256 cellar: :any_skip_relocation, ventura:        "821dc4f30292c05ba5abe7745c4c1bba2aa8aa7f792fa8538106a172d1947778"
    sha256 cellar: :any_skip_relocation, monterey:       "7071314a25934c2645dbb730160f0fbbd0905865591e187fb29cc9d7442efe58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82dbab91f078eb9df2ae011963e853a925b75cb1a8a59b351be3a467b4ad396b"
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
