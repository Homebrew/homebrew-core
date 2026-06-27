class Pmccabe < Formula
  desc "Calculate McCabe-style cyclomatic complexity for C/C++ code"
  homepage "https://gitlab.com/pmccabe/pmccabe"
  url "https://gitlab.com/pmccabe/pmccabe/-/archive/v2.9/pmccabe-v2.9.tar.bz2"
  sha256 "8b0e207c171bb3c8b9dcc226b85a8a8f1f87c98cc8e71e760a99c3058042ec48"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[._]\d+)+[a-z]?)$/i)
    strategy :git do |tags, regex|
      tags.map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "390360b12123add592c3b8c8b9fb1a7009de3c4a41d0a874af226e78abfafc86"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5dbd167ff346c7f8b94537ae292dcf9cda189607d6410eab88d2adbc1599b92"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e35eaa8effa7966add3c7a467b01cc48a24c86c25a4ac7fc3273d4512a49973"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b31af20d1a864ad28bc3a587595e1193d443c5dff69f7115197f762c993aa9b"
    sha256 cellar: :any,                 arm64_linux:   "c8d6cb84fb07671cffe885b44b2edae013195d0fced4e82e6f12f902050136d4"
    sha256 cellar: :any,                 x86_64_linux:  "9382a759df3c0fc9fea73ace5ff5d5c6f1b4b60b12cb9bf94a75749ac44491b2"
  end

  def install
    ENV.append_to_cflags "-D__unix"

    system "make", "CFLAGS=#{ENV.cflags}"
    bin.install "pmccabe", "codechanges", "decomment", "vifn"
    man1.install Dir["*.1"]
  end

  test do
    assert_match "pmccabe #{version}", shell_output("#{bin}/pmccabe -V")
  end
end
