class Dbr < Formula
  desc "Barcode SDK for 1D, QRCode, DataMatrix and PDF417"
  homepage "https://www.dynamsoft.com/Products/Dynamic-Barcode-Reader.aspx"
  url "https://download.dynamsoft.com/dbr/dbr-mac-5.2.0.zip"
  sha256 "34fa6a39ace60f768b2bd46606ac995d3a3881a8169313f6aeabefa2dae08c38"

  def install
    include.install Dir["BarcodeReader5.2/include/*"]
    lib.install "BarcodeReader5.2/lib/libDynamsoftBarcodeReader.dylib"
    doc.install Dir["BarcodeReader5.2/documents/*"]
  end

  test do
    system "false"
  end
end
