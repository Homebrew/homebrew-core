class Jvgrep < Formula
  desc "Grep for Japanese users of Vim"
  homepage "https://github.com/mattn/jvgrep"
  url "https://github.com/mattn/jvgrep/archive/refs/tags/v5.8.16.tar.gz"
  sha256 "f337724a802867998187157644fce61929b3795728c09bbd7ea8386f6d43ace6"
  license "MIT"
  head "https://github.com/mattn/jvgrep.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c33ed09adb2427fbfdf4e954d18f857efe45cea3b708f570d60b1d92101dac6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c33ed09adb2427fbfdf4e954d18f857efe45cea3b708f570d60b1d92101dac6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c33ed09adb2427fbfdf4e954d18f857efe45cea3b708f570d60b1d92101dac6"
    sha256 cellar: :any_skip_relocation, sonoma:        "462610c9365f48db395b8640036e607dc4c2d90d747e46e48bc3d4947a299d6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb6ce31a89ff7bda2f71292ba30cc60fcf54a00d0dfbf920f7c7e07f4d9fe79f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "186486fa0c0488ab1bedc0b8471774334e180ca053532f9c97cdd653dc347ef0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"Hello.txt").write("Hello World!")
    system bin/"jvgrep", "Hello World!", testpath
  end
end
