class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://github.com/moonrepo/moon/archive/refs/tags/v1.22.7.tar.gz"
  sha256 "fa1b0846f4982ea029d0f1ee810991e966abdf10ea67b50abb7070604f0cb075"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d207a6ac1ad801c0f8e44c1898944994979ecdc10eb986d07e017c5f64cc54b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ea618fce4b1d44d4cbf2ee7f16a6e67e3df06e374749433a97a7f101fd910985"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02b72487e38ceeb3b3a444aa9ede72d4b00a2162efb7badcf5b62f38dc1d197b"
    sha256 cellar: :any_skip_relocation, sonoma:         "c50ea3624e836897373327636f35317dfc9b0643a73e70a7d05f7c7d456d65f8"
    sha256 cellar: :any_skip_relocation, ventura:        "584c9e2f558e641ee237eb3cbaee6d00f96bf6088546751c3a7bd573addcd3a7"
    sha256 cellar: :any_skip_relocation, monterey:       "be9906e908a38e431967ba8261de9d7c119afd5e44698a1a5bad67ddbd7f6e42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d98ab3fa63b1a1b39536afedbabdb7e5e8317b21ad231028627c0f79c50b584"
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
