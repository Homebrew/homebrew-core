class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://github.com/moonrepo/moon/archive/refs/tags/v1.31.2.tar.gz"
  sha256 "5b7eb3d360caee2173d14b1344393f4f4263d49e195d96fffae5a410cbd1aa88"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2dd2576060e81ecd3e4e79c56f970edeb15bdebaf7e0d9cb24be3b5123499fa4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "795e4c861bbc4acfc1ec521ad9ebdede5b979e6f2221aec160b3c356da3d8b54"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6827470368ef396a8c67bdf9163e77f5f2206935919af3d15d09f6bd8c5420a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c32d9b394cd6e4b03ecf969b572309bcda3f8d933c38bca8ace36ffb126b347"
    sha256 cellar: :any_skip_relocation, ventura:       "e3fd08e945bf5dd59199a9fe529a329581f38ef0ee54fbe0f844f6cbc61842a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4243212ebaca674ba370e39ff6ce44ea5a99d5027770d4b26e26612c16563e9f"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

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
    assert_path_exists testpath/".moon/workspace.yml"
  end
end
