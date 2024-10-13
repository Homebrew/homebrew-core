class GnustepMake < Formula
  desc "Basic GNUstep Makefiles"
  homepage "https://gnustep.github.io/"
  url "https://github.com/gnustep/tools-make/releases/download/make-2_9_2/gnustep-make-2.9.2.tar.gz"
  sha256 "f540df9f0e1daeb3d23b08e14b204b2a46f1d0a4005cb171c95323413806e4e1"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^make[._-]v?(\d+(?:[._]\d+)+)$/i)
    strategy :github_latest do |json, regex|
      json["tag_name"]&.scan(regex)&.map { |match| match[0].tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f88168f1fd86d2eee0d19bcb8ade8c17515bf9706e61ea2694f49c8f41774cb3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "531eaad8344043d38f8ffb4df0bf8948113a9f2ff226c7ef6b10fb974a966276"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5f79daeb6f99aa9b9fd8f45dd905208f3527900115299d418da0e549815ddb64"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "385e58fbe30b9744c66b3295e2e56e7c7750ff3152e68efcab19116d954267a2"
    sha256 cellar: :any_skip_relocation, sonoma:         "4f6357007789df86e36d882bfd3b6dd2e37a56ae242293ad5e914a05bb154d6a"
    sha256 cellar: :any_skip_relocation, ventura:        "9146a6091740cf4ad4db83d3510692fb5d3d8eb09b3e4e98e8e83b737341b5a1"
    sha256 cellar: :any_skip_relocation, monterey:       "0d56ab699916276b610d1b2fac92c75c90cf7ed3e03e0cfb91fb7120c5718a27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "586fa4113dc1ff0d8fdb64e9cb8e66de8a6d2feef712992c5312641d5941c737"
  end

  def install
    system "./configure", *std_configure_args,
                          "--with-config-file=#{prefix}/etc/GNUstep.conf",
                          "--enable-native-objc-exceptions"
    system "make", "install", "tooldir=#{libexec}"
  end

  test do
    assert_match shell_output("#{libexec}/gnustep-config --variable=CC").chomp, ENV.cc
  end
end
