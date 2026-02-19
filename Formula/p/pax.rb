class Pax < Formula
  desc "Portable Archive Interchange archive tool"
  homepage "https://mbsd.evolvis.org/pax.htm"
  url "https://mbsd.evolvis.org/MirOS/dist/mir/cpio/paxmirabilis-20240817.tgz"
  sha256 "e955d5d3af97aede0a3f463a9a59b83e8d1083aaf142eb6f388c549a7d182e6b"
  license "MirOS"

  livecheck do
    url :homepage
    regex(/href=.*?paxmirabilis[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d22fadfbcbb47721a7e9730f8ce344c3c2cfc235f6387dfaf12be14b24039829"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ac5cccaffe97f01cef5e2615cc7e7b5832226d1773610ca19df65f54d35326a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be97ffea4bf07def65a7c6182a24dd61a15361350b4f5ca1454042cb41d5eeac"
    sha256 cellar: :any_skip_relocation, sonoma:        "83b945fe0ebf5f46d96c800b7f14ca9b14b73354a6657fbc72f0859a784f150b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22f8528e91508715e5ee7836a7de29eae46fc443ecd1d3380b4e88e066ee73f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d5d9e3bf21a76cea2fa56e009f1750c8252ac9d8356879efa3428484c477329"
  end

  keg_only :provided_by_macos

  def install
    mkdir "build" do
      system "sh", "../Build.sh", "-r", "-tpax"
      bin.install "pax"
    end
  end

  test do
    (testpath/"foo").write "test"
    system bin/"pax", "-f", testpath/"foo.pax", "-w", testpath/"foo"
    rm testpath/"foo"
    system bin/"pax", "-f", testpath/"foo.pax", "-r"
    assert_path_exists testpath/"foo"
  end
end
