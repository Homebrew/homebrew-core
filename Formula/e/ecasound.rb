class Ecasound < Formula
  desc "Multitrack-capable audio recorder and effect processor"
  homepage "https://nosignal.fi/ecasound/"
  url "https://nosignal.fi/download/ecasound-2.9.3.tar.gz"
  sha256 "468bec44566571043c655c808ddeb49ae4f660e49ab0072970589fd5a493f6d4"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://nosignal.fi/ecasound/download.php"
    regex(/href=.*?ecasound[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "12e39a10c26842235843e303cf99bb10db7666a1fcd812d88b418ed2eae540c0"
    sha256 arm64_sequoia:  "44c42355a7959b320035dc42229da1ea6996934e220820a8e51c8c9b45e882ed"
    sha256 arm64_sonoma:   "fdcc51560354d8507e799d8d6e9f61b77cc31daddcc76afb058e78049d10695f"
    sha256 arm64_ventura:  "0e52338802663453eb4ed6cd44967b7b2baf80b5cc133a4ae42c36f6e4208fed"
    sha256 arm64_monterey: "73ca5b440adf4626dea12d21da27ecc13d76829efee851e8160dedb78709023d"
    sha256 arm64_big_sur:  "3032ed920ff4b40250c2c1efcd19a591e0df1b2714159aed9fd6ea4db094af4c"
    sha256 sonoma:         "24eb9f25ca01a39404831b629ce7891bf14c5749bbc4697a1fa9ed2061f067de"
    sha256 ventura:        "ee2fba8822efd205930d9b0329d54d2175eb14043d19aeea77130acc193dece7"
    sha256 monterey:       "34a6f3f1ac115bd659329799ee74b5d3a04fdf5a2bb5c8b99d6786c5a81d1283"
    sha256 big_sur:        "d3a693686266e5570afbd54ecaede7930145c6a69461e7839c97857b373c63f6"
    sha256 catalina:       "f6fede56fea73bdfd32cebd514448b50dec47542ff7d76342f950a61160a9fff"
    sha256 arm64_linux:    "ab701f376ed4da40ce109998841784880580ad6b2cb13c5f97cdcb50dffb10fd"
    sha256 x86_64_linux:   "6c81d3065ae81f06d5c338aa6d892be6916c1215c5cb6c6cfd57f60d2249dd2e"
  end

  depends_on "jack"
  depends_on "libsamplerate"
  depends_on "libsndfile"

  uses_from_macos "ncurses"

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    args = %w[
      --enable-rubyecasound=no
      --enable-sys-readline=no
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    fixture = test_fixtures("test.wav")
    system bin/"ecasound", "-i", "resample,auto,#{fixture}", "-o", testpath/"test.cdr"
    assert_path_exists testpath/"test.cdr"
  end
end
