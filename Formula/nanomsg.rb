class Nanomsg < Formula
  desc "Socket library in C"
  homepage "https://nanomsg.org/"
  url "https://github.com/nanomsg/nanomsg/archive/1.2.tar.gz"
  sha256 "6ef7282e833df6a364f3617692ef21e59d5c4878acea4f2d7d36e21c8858de67"
  license "MIT"
  head "https://github.com/nanomsg/nanomsg.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "308cf4314ea400020c0b85222f3fe0fb09f80ad204c1e2bc6271f0011df14feb"
    sha256 cellar: :any,                 arm64_monterey: "dcfbd463f07433a38c053f412678fcf5eb718ba13bafc86930bac6c7af651d55"
    sha256 cellar: :any,                 arm64_big_sur:  "78c5546a8a36be470a1aab0bfd05c473e841981ce51388ea395dcc94ce5c7a93"
    sha256 cellar: :any,                 ventura:        "4cd22f2ae9bcccba55906434a857271ece101a8ce4bf2fb554d5b9fe8fa146fb"
    sha256 cellar: :any,                 monterey:       "112db66905b5f3b99bc8740e33b7735a5ea3da4eb4d5e14ddd466c736b24e4eb"
    sha256 cellar: :any,                 big_sur:        "4ef65cd7590b96d868f21168e970892fdbe216f3bc0a74beb35006b24049b6ea"
    sha256 cellar: :any,                 catalina:       "421059d935dabba7625c58d56408f0658dab708c3dae59caf7f459c38d9bb632"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "099a03bfe5111a28fe413cc3e15958844adaf5324b68f86d30497ad4a87ded53"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    bind = "tcp://127.0.0.1:#{free_port}"

    fork do
      exec "#{bin}/nanocat --rep --bind #{bind} --format ascii --data home"
    end
    sleep 2

    output = shell_output("#{bin}/nanocat --req --connect #{bind} --format ascii --data brew")
    assert_match "home", output
  end
end
