class GnustepMake < Formula
  desc "Basic GNUstep Makefiles"
  homepage "https://www.gnustep.org/"
  url "https://github.com/gnustep/tools-make/releases/download/make-2_9_3/gnustep-make-2.9.3.tar.gz"
  sha256 "93ca320b706279ebca53760da89d4c3f2bbc547f4723967140a34346d9f04c24"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^make[._-]v?(\d+(?:[._]\d+)+)$/i)
    strategy :github_latest do |json, regex|
      json["tag_name"]&.scan(regex)&.map { |match| match[0].tr("_", ".") }
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a29d1ad79d1152ed28bc6546a528883d211c120b55c83ba848a210f1d68e773"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1408996d17615db43b394bef9a1bda04059ee607901189ec75b7fd824e12a78d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a1dc5ebf1c4abc7ee6df941f4fec23ab549a41634715e06747bdead843ed657"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9c5609ff238b2cd81172d4127d84283ac2c46c2f4e1134ab0e46110744e91d86"
    sha256 cellar: :any_skip_relocation, sonoma:        "1deda0f98bdf01ca889ebb9c17b7232dd19b2548f456c71396db1423a4f1f25e"
    sha256 cellar: :any_skip_relocation, ventura:       "acca702d1efc0af0f7bcff2eb13272b165bc72d566fede6bc0271247588c8c49"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "485142f894eec86581275e476081b45c972bf52c5c8102173f1b8543802f8a02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7828040571e064d2b983a3324119f5232af9fa54da624eb1f52ae2c517aab7d5"
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
