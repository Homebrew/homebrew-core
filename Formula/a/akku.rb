class Akku < Formula
  desc "Package manager for Scheme"
  homepage "https://akkuscm.org/"
  url "https://gitlab.com/-/project/6808260/uploads/44040730f50c8a202e8d39b2c3a8f377/akku-1.2.0.tar.gz"
  sha256 "4ed046a5d08ee05d4c3f246e7a890485fc93d4fec25dd0600ed64a303e1183b2"
  license "GPL-3.0-or-later"
  head "https://gitlab.com/akkuscm/akku.git", branch: "main"

  livecheck do
    url "https://gitlab.com/api/v4/projects/6808260/releases"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :json do |json, regex|
      json.map { |item| item["tag_name"]&.[](regex, 1) }
    end
  end

  bottle do
    sha256 arm64_golden_gate: "37e126f095dc67e5b18a65b47b7a355469bc342162cfe3ef887d127483033326"
    sha256 arm64_tahoe:       "457250776255ad2fb9c09e9c6f1359e1abf0a27c2149f79ee2b22905c181ce6c"
    sha256 arm64_sequoia:     "b0bb1fc129fb8dc57b718a680b48ba47ba06b9355292ba58fcae8e63a20c2881"
    sha256 arm64_linux:       "63236c2d35f1582bc778671f52cd94bee6a6877b4271d41c84416fb958f1086d"
    sha256 x86_64_linux:      "5ecb9b8fb57b0a716f77474c94ac92c4bebcdee9647e8a91db5bc5a5169cf4d5"
  end

  depends_on "pkgconf" => :build
  depends_on "guile"

  uses_from_macos "curl"

  deny_network_access!

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"akku", "init", "brewtest"
    assert_path_exists testpath/"brewtest/brewtest.sls"
    assert_match "akku-package (\"brewtest\"", (testpath/"brewtest/Akku.manifest").read
    assert_match version.to_s, shell_output("#{bin}/akku --help 2>&1")
  end
end
