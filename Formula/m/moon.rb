class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://github.com/moonrepo/moon/archive/refs/tags/v1.23.4.tar.gz"
  sha256 "2298b231d064d7ef0a1de5fe1ef3edb6117bde16db15aa6bce35c35926086ccc"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "33766d3b392c3fad9d04dd43685f3ce3228af764f1a8e5441d3ef288fa72ca24"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6eee0c8e659eb7c60154723df9424324abea1567dac43354bff76e8006daa514"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "224ae6d4738b1e4391a7ac300f8ab00ac1902bbbcdd8482b7556c7abb3731a6b"
    sha256 cellar: :any_skip_relocation, sonoma:         "262cc44917e8ab52fc31495be4243edb59e6f006d4e61c27c4e4c7d991a640bb"
    sha256 cellar: :any_skip_relocation, ventura:        "73c83eaf0ecd6038c9e74163c12f7c63799eb8024522fcccc590c74481d109d6"
    sha256 cellar: :any_skip_relocation, monterey:       "7da6a5cab1bbc89a580f652aba370c7c34da29da68108324bf3ae298b5bf9317"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "274427209c2264f5db98e26d0cd0bafda109c6a053d8e13737abe472d9d75f9b"
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
