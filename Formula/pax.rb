class Pax < Formula
  desc "Portable Archive Interchange archive tool"
  homepage "https://www.mirbsd.org/pax.htm"
  url "http://www.mirbsd.org/MirOS/dist/mir/cpio/paxmirabilis-20201030.tgz"
  sha256 "1cc892c9c8ce265d28457bab4225eda71490d93def0a1d2271430c2863b728dc"
  license "MirOS"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d53b2b5ce68a30ac206d6692afd3340abbb4b017922fee78db2f9fb1455c55a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4439e9d997f1e26eb76c01c5bded88103475e8867855e2b0928eae5175e974b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e540a64c9273304c80db0069305aa90efd4151a1dfd0f9eca0afdb640636a01b"
    sha256 cellar: :any_skip_relocation, ventura:        "1d63a2f030b177f7b13a4150dadde6c3a2c843a8a15535f7a66375029feda72e"
    sha256 cellar: :any_skip_relocation, monterey:       "d38daea0b26ae854ac1b08b4e3df4689b9ebbc7658604ea0d61fae0a3d263933"
    sha256 cellar: :any_skip_relocation, big_sur:        "3bee37a3e3c998d25eb643ba3b5883d423b2209caf40f8f950f0ea72d0413f4c"
    sha256 cellar: :any_skip_relocation, catalina:       "7445d8ab0193bfc4e2bb4c8a7497e8010cb47b63bb9fa49c887b2f3a3e133d6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ebf0c050c23153d61d4bd703a0f9a4194018a54ad873a5594a70182058280ec"
  end

  on_macos do
    keg_only "provided by macOS"
  end

  def install
    mkdir "build" do
      system "sh", "../Build.sh", "-r", "-tpax"
      bin.install "pax"
    end
  end

  test do
    (testpath/"foo").write "test"
    system "#{bin}/pax", "-f", "#{testpath}/foo.pax", "-w", "#{testpath}/foo"
    rm testpath/"foo"
    system "#{bin}/pax", "-f", testpath/"foo.pax", "-r"
    assert_predicate testpath/"foo", :exist?
  end
end
