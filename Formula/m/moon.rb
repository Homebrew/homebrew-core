class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://github.com/moonrepo/moon/archive/refs/tags/v1.25.4.tar.gz"
  sha256 "819e9a9444e869d6b1e8e8fa69c4bd82e4121a80df776da15d1aeb92efeffadb"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4d75e49db5f278835d5c1e2f1448762c5c0e0364764f620e6ef694ee5d841e23"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "188f9c6284c386185e9b2fb5a07591d8551e495920dfed6b39eb3c5c37e7d8cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e78911c4c48e8629f7eb2a7c6b6471c332249578ae5339deff46bf8a47a8602"
    sha256 cellar: :any_skip_relocation, sonoma:         "2815cee65412f25a302bee4fad94e4afab018268faec306672cc54fbfaee6874"
    sha256 cellar: :any_skip_relocation, ventura:        "6ff024646e5b3377b3a1d12f697b3ed744df7baf40ef3fe7672717c6afcd604b"
    sha256 cellar: :any_skip_relocation, monterey:       "714a4f1160ee44985ed75e0d263b25dc5a3b75024342399d40bc2fc0adc211b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a41f71a70bb75b7befa8f1882c7574476345566b471b693efba1ea0353adbeef"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
    depends_on "xz"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "legacy/cli")
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
