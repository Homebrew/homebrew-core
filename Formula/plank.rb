class Plank < Formula
  desc "Framework for generating immutable model objects"
  homepage "https://pinterest.github.io/plank/"
  url "https://github.com/pinterest/plank/archive/v1.4.1.tar.gz"
  sha256 "021889470c1568364fb12e3c704ab98e74c5992749a244a1ef785dd870cad57b"

  bottle do
    cellar :any_skip_relocation
    sha256 "a8ef5d8f039de6c40a87101d69a0fea96a151008fc72796be3d1eb1598d465c8" => :mojave
    sha256 "b5731e67f8155038764e927d6363c16f04cce69edc3c25bff78d9c39beaae4f9" => :high_sierra
    sha256 "374262fdc60398fdf217c8bb2e458641ce683eb5dc6c5979cea84f0a5a4adc82" => :sierra
  end

  depends_on :xcode => ["9.0", :build]

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"pin.json").write <<~EOS
      {
        "id": "pin.json",
        "title": "pin",
        "description" : "Schema definition of a Pin",
        "$schema": "https://json-schema.org/schema#",
        "type": "object",
        "properties": {
          "id": { "type": "string" },
          "link": { "type": "string", "format": "uri"}
         }
      }
    EOS
    system "#{bin}/plank", "--lang", "objc,flow", "--output_dir", testpath, "pin.json"
    assert_predicate testpath/"Pin.h", :exist?, "[ObjC] Generated file does not exist"
    assert_predicate testpath/"PinType.js", :exist?, "[Flow] Generated file does not exist"
  end
end
