class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://github.com/moonrepo/moon/archive/refs/tags/v1.24.4.tar.gz"
  sha256 "6b714ae8fe2664569318313d269a17c1e7ea8032b181eaef3eb800fc88ae67b3"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d8fe02244f568ffa71d6122bde8d9ac37b76dd2faa28162a3cae86a04241358b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ffa32d405a6df3115bc805902c10d8ccba0fd85e11aae3cbd793d1514f7ae19d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4975efaf9b09371ab9d02035060c9ab22f6626d4026050471c83b2d8b2383059"
    sha256 cellar: :any_skip_relocation, sonoma:         "a6148e14241007f87830d1b934202a33721cd08e7082ad6c79d489a953eba51e"
    sha256 cellar: :any_skip_relocation, ventura:        "65e0bec8f2f70c33b0958ffca0658c5f7156eaaca7d8fe735e9f1ed35be41640"
    sha256 cellar: :any_skip_relocation, monterey:       "f7913213b53c007a07ab137b9a6673268d50a0179da5bd6b72d318ca89e4a222"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6fd3eba91f3a9e9f2d05b9fd71152c2cc0ad2e7392cb8cd8b7fe54fa74e0d24"
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
