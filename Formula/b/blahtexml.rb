class Blahtexml < Formula
  desc "Converts equations into Math ML"
  homepage "https://github.com/gvanas/blahtexml"
  url "https://github.com/gvanas/blahtexml/archive/refs/tags/v1.0.tar.gz"
  sha256 "ef746642b1371f591b222ce3461c08656734c32ad3637fd0574d91e83995849e"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "c45cfbdf6d5aa58274631b5fc583b42ca0f0e5d80866dc8c3620e1f9f2d6f883"
    sha256 cellar: :any,                 arm64_sonoma:   "f2fa3f37ba34fe8b733fd1c0253606fd4ed3dea27fc3065b87ea6f5e4194c51b"
    sha256 cellar: :any,                 arm64_ventura:  "db64fdc2a7df77d68c7530ea4285ae78bcf601088c7e77acea81f529ac469446"
    sha256 cellar: :any,                 arm64_monterey: "893abf6f661a0ba1d90d7dc42bdb1c3ba83ce1799b5b99c4b442a8559cb1d71b"
    sha256 cellar: :any,                 arm64_big_sur:  "de3e5596434795f4afd9439f639a26ebcd8007f4050176ab3dd46cda795a7e9c"
    sha256 cellar: :any,                 sonoma:         "08642c5fc90bb274742c682b303ef71aaffbe00b9a4383f4cad246144a2f60b5"
    sha256 cellar: :any,                 ventura:        "9e6c88b7639416423b74abf8ed3c0c25e412ee42bfc7452d8cd0ff26e1183713"
    sha256 cellar: :any,                 monterey:       "ca50dc5a8d4e300ab143f1dd92f182c792fa5f1b6840333c4944e1c5f48cbc2f"
    sha256 cellar: :any,                 big_sur:        "97e4a9e3841ec8fd6c13db2ee2a02c57b0896501296b5da82f510a676482e7d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5874a0c9f4890d39638a59e7360f5e2bc7dbd4d51da536276b181b61733cdd1"
  end

  depends_on "xerces-c"

  def install
    ENV.cxx11
    if OS.mac?
      system "make", "blahtex-mac"
      system "make", "blahtexml-mac"
    else
      system "make", "blahtex-linux"
      system "make", "blahtexml-linux"
    end
    bin.install "blahtex"
    bin.install "blahtexml"
  end

  test do
    input = '\sqrt{x^2+\alpha}'
    output = pipe_output("#{bin}/blahtex --mathml", input)
    assert_match "<msqrt><msup><mi>x</mi><mn>2</mn></msup><mo ", output
  end
end
