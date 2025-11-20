class Entr < Formula
  desc "Run arbitrary commands when files change"
  homepage "https://eradman.com/entrproject/"
  url "https://eradman.com/entrproject/code/entr-5.7.tar.gz"
  sha256 "90c5d943820c70cef37eb41a382a6ea4f5dd7fd95efef13b2b5520d320f5d067"
  license "ISC"
  head "https://github.com/eradman/entr.git", branch: "master"

  livecheck do
    url "https://eradman.com/entrproject/code/"
    regex(/href=.*?entr[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b8841519d0ce82f1a8c52246050ed758c7be32e84e86bf7b93f6d57d1683121"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa513900e241782d8d90998fc2c5e7a817f04e33120aeb1ca2db659120f3b4b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "802982cec1f0f4ca2123e5afe40aaf2709ef11de882a54516a0c435dbda233f1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "badd684160fe6618cae3938877a687d10951cea937fb4ed9dffb2c121a20317e"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf673e248b9ecff9457c892d56142fe10bd6dc4136929105e65a5fc081b11b2f"
    sha256 cellar: :any_skip_relocation, ventura:       "79f31d0171888953a7dca0685b335eec0983ef12a473458f81be0a07d10a2108"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6a4062b80d77c0c7ea22591b2bea9496842c92b989b435554225a3c16f7d827"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e44cb7f98f576a76445eaaf449da0b730302b127e072f7ddfd6e01c85a3fef7"
  end

  def install
    ENV["PREFIX"] = prefix
    ENV["MANPREFIX"] = man
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    touch testpath/"test.1"
    fork do
      sleep 2
      touch testpath/"test.2"
    end

    assert_equal "New File", pipe_output("#{bin}/entr -n -p -d echo 'New File'", testpath.to_s).strip
  end
end
