class Liblinear < Formula
  desc "Library for large linear classification"
  homepage "https://github.com/cjlin1/liblinear"
  url "https://github.com/cjlin1/liblinear/archive/refs/tags/v250.tar.gz"
  version "2.50"
  sha256 "c875bab4d5ae53a5b48a91081c66f39a0bd2524f49e934dcdaed90284dd605e4"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/cjlin1/liblinear.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d)(\d+)$/i)
    strategy :git do |tags, regex|
      tags.filter_map do |tag|
        match = tag.match(regex)
        next if match.blank?

        "#{match[1]}.#{match[2]}"
      end
    end
  end

  bottle do
    rebuild 1
    manifest_sha256 "326526aa0ae4140e2400413451487e55cc69df85e6e1b908026b60161dac9165"
    sha256 cellar: :any, arm64_golden_gate: "086adcd21fcd8282611df45aa50c11bba7c0f7853e67411b99f4b7c824a798b0"
    sha256 cellar: :any, arm64_tahoe:       "ead4d4e962f26d4e2771f04c2c60256116dbc4390dcf688ee11e4e5d2884b515"
    sha256 cellar: :any, arm64_sequoia:     "5813c0b3b108d40de56b17316ee0f6eb9c298f241477b1787b49b1a8b6b663ca"
    sha256 cellar: :any, arm64_linux:       "f33603915c87542a965c48074503e3426f410da3823bb47ea7b3987878d1c016"
    sha256 cellar: :any, x86_64_linux:      "6e1f3fdb7156a9a8ccf49c61a51f67ef1e0c26bcfa6d72a35ec3bc4df8f15d4f"
  end

  # Fix sonames
  patch :p0 do
    file "Patches/liblinear/patch-Makefile.diff"
  end

  deny_network_access!

  def install
    soversion_regex = /^SHVER = (\d+)$/
    soversion = (buildpath/"Makefile").read
                .lines
                .grep(soversion_regex)
                .first[soversion_regex, 1]
    system "make", "all"
    bin.install "predict", "train"
    lib.install shared_library("liblinear", soversion)
    lib.install_symlink shared_library("liblinear", soversion) => shared_library("liblinear")
    include.install "linear.h"
  end

  test do
    (testpath/"train_classification.txt").write <<~EOS
      +1 201:1.2 3148:1.8 3983:1 4882:1
      -1 874:0.3 3652:1.1 3963:1 6179:1
      +1 1168:1.2 3318:1.2 3938:1.8 4481:1
      +1 350:1 3082:1.5 3965:1 6122:0.2
      -1 99:1 3057:1 3957:1 5838:0.3
    EOS

    system bin/"train", "train_classification.txt"
  end
end
