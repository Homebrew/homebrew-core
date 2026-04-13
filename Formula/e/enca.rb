class Enca < Formula
  desc "Charset analyzer and converter"
  homepage "https://cihar.com/software/enca/"
  url "https://github.com/Project-OSS-Revival/enca/releases/download/1.22/enca-1.22.tar.xz"
  sha256 "95a70dd21198e6427d77a1d79721f4f87dd8bd07fdefe71a2062c6f41eee39da"
  license "GPL-2.0-only"
  head "https://github.com/Project-OSS-Revival/enca.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "186d5551a3f3b293b464cb9d8b2f00f9a8d23d8c7488593cfb301133fe7c47d2"
    sha256 arm64_sequoia: "b6d87405f58557daf9bb694f39de18da6cfb4364980cea4bc6514dfeb83a948e"
    sha256 arm64_sonoma:  "b12040e349cb6a5db5042b4cca7b8fa10b6302a4d55fe80bfb09fe3dbc271cd2"
    sha256 sonoma:        "0756a5511840591047a2b8f81c2c77bafe9c65c73d82195a43fe22e5c0213cf0"
    sha256 arm64_linux:   "cdc368ac529c459ac9453ecd1789ea7ab70911415a1a73b247323e8036a6bafe"
    sha256 x86_64_linux:  "4ee249a13bafbc6ac78d69fbfd642546b73b68757a89d7e21d54ecd9172eec4a"
  end

  def install
    ENV.append "LIBS", "-liconv" if OS.mac?

    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    enca = "#{bin}/enca --language=none"
    assert_match "ASCII", pipe_output(enca, "Testing...")
    ucs2_text = pipe_output("#{enca} --convert-to=UTF-16", "Testing...")
    assert_match "UCS-2", pipe_output(enca, ucs2_text)
  end
end
