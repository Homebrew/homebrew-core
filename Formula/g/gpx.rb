class Gpx < Formula
  desc "Gcode to x3g converter for 3D printers running Sailfish"
  homepage "https://github.com/markwal/GPX/blob/HEAD/README.md"
  url "https://github.com/markwal/GPX/archive/refs/tags/2.6.8.tar.gz"
  sha256 "0877de07d405e7ced8428caa9dd989ebf90e7bdb7b1c34b85b2d3ee30ed28360"
  license "GPL-2.0-or-later"
  head "https://github.com/markwal/GPX.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "b22447a95c344cc87486222b09771e583af5854f2f8e14b57dd833af9bd88546"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "4cce4b9145a373c3c34a20ebf23371a7927d0de776d583dca2b9e711ca07e30d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "61e0254f04e3d84c686ebdc03b55e1e8cfdbf8763a562d7bebb098e9a350216d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "17010f57abfa7f6ad4f72d6859ddf2953c7032d8bce6e5cf4d83d5d9785e6a33"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ae5844965495fca29278f5af6319d2adc2f7d0d7c246ec33671def99d25d77d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "60d8a577b0d45216452c475ff07e4641aec56c599a491c00409530a8fc5db856"
    sha256 cellar: :any_skip_relocation, sonoma:         "dbbe6d2352c73b6d6fd701e1ea6abf4b9b0140c4341e1274f145299b93fe2658"
    sha256 cellar: :any_skip_relocation, ventura:        "44f9dbf09fa8b6816aef12f79fe43f0d377e847fb746aca99d041fd48eaa023a"
    sha256 cellar: :any_skip_relocation, monterey:       "ce1628d7dc88475fe74bbc6636bc193ee01a02481c9043373cb424f61074847e"
    sha256 cellar: :any_skip_relocation, big_sur:        "254414afa9fe68137739444a5c514637131eac89d208239d4de86d953bbed5cd"
    sha256 cellar: :any_skip_relocation, catalina:       "a982edd4fb776a077ea51294aea03533e5672dea8a7710329aadc2a3adca9ad1"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "14c39a870eabe876ac4f7c93fde5b4821a7afaf9409a1445db1a7b4117d980fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50b29dd66920ad57a1f25ca2da7bd5cbed6f73ae4141fdc6fc9a07fb2166496c"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.gcode").write("G28 X Y Z")
    system bin/"gpx", "test.gcode"
  end
end
