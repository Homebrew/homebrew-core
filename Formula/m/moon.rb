class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://github.com/moonrepo/moon/archive/refs/tags/v1.22.9.tar.gz"
  sha256 "9b04204a7c895a12891383ca603ae5a6149a8353d7f5982629844f512b9247c1"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2853b31d8491565a9a425b3333cd704b66473687daa3c27a77b3e211dd844a97"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "621d40820be68bde15649135999ba0f60189c8920c6d93b92335c9e695f47dfa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c71790963fc7d1ed41c0f7e39eaf0a43b3a0b7f3e9f0b0e96bc2f6528c59e96b"
    sha256 cellar: :any_skip_relocation, sonoma:         "2c9e0db040ff9c44d20e8a184f7277994e4ca89add4b169a6578032f02ad01b9"
    sha256 cellar: :any_skip_relocation, ventura:        "84d3fa550ecdfd194673be1e057ccec83228e4362923548f01f9fc323c9e2517"
    sha256 cellar: :any_skip_relocation, monterey:       "f9341c0fba56fdc38c2bf182c8a9e43f80b68d05dfb4ad8e6451490843221cc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d4ca9f1ce5f7fe2b0c911ac81374d63cb61145722e60370fc8fefe30173e63b"
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
