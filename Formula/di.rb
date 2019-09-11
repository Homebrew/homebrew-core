class Di < Formula
  desc "Advanced df-like disk information utility"
  homepage "https://gentoo.com/di/"
  url "https://gentoo.com/di/di-4.47.1.tar.gz"
  sha256 "eea8ad94197d9f11790afea0924d8bf29ec001c32eb6209e81c4e13766a2abad"

  bottle do
    cellar :any_skip_relocation
    sha256 "ac66afaf91adbe32a27b6f9f2642abe2f72f2be4e89cd135c0b24bf5d29363e5" => :mojave
    sha256 "d56258c488485a6d10789cd051687d94dd60974fce12d575af0766254588392d" => :high_sierra
    sha256 "4d351a2e919590ff239fad5871ce20001cf6246af03fac69a3f721bf89140a8d" => :sierra
  end

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/di"
  end
end
