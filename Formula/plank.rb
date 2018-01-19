class Plank < Formula
  desc "Framework for generating immutable model objects"
  homepage "https://pinterest.github.io/plank/"
  url "https://github.com/pinterest/plank/archive/v1.2.1.tar.gz"
  sha256 "21d15335bdf2f229a886611f3d18138b4a41ccbf420809dc3be1da41d3868104"

  bottle do
    cellar :any_skip_relocation
    sha256 "b11dd6d04d4560d28ede31d5ee3812c9fa8080539918d701957b800d9bd9d827" => :high_sierra
    sha256 "a893af40dcfb3c2d524456aa294ab6dec0a64b47b5b0880982f805e9b5db7977" => :sierra
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
        "$schema": "http://json-schema.org/schema#",
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
