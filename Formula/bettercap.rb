class Bettercap < Formula
  desc "Swiss army knife for network attacks and monitoring"
  homepage "https://www.bettercap.org/"
  url "https://github.com/bettercap/bettercap/archive/v2.26.1.tar.gz"
  sha256 "75530015ee27e5ba05faff0295486ca85489ecd9de3161ca398a9b577522c578"

  bottle do
    cellar :any
    sha256 "91a85e1c0118e7d5c31b9a1f8fd9ad3b4fca7a57722910099460e84f14f4b553" => :catalina
    sha256 "241b85a1ce777e9fe9e8d8408afd46fc613c4cf691c1be3c3dbc35e8bde215b0" => :mojave
    sha256 "dceaab3973b28c4cc88629a4a192d0da1d6ce2ed602260d5dda83e75132295a9" => :high_sierra
  end

  depends_on "dep" => :build
  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb"

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/bettercap/bettercap").install buildpath.children

    cd "src/github.com/bettercap/bettercap" do
      system "make", "build"
      bin.install "bettercap"
      prefix.install_metafiles
    end
  end

  def caveats; <<~EOS
    bettercap requires root privileges so you will need to run `sudo bettercap`.
    You should be certain that you trust any software you grant root privileges.
  EOS
  end

  test do
    assert_match "bettercap", shell_output("#{bin}/bettercap -help 2>&1", 2)
  end
end
