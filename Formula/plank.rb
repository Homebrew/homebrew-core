class Plank < Formula
  desc "Framework for generating immutable model objects"
  homepage "https://pinterest.github.io/plank/"
  url "https://github.com/pinterest/plank/archive/v1.5.tar.gz"
  sha256 "bc616c6baa00d66656efb451540bafec2a159047e11037a9e134f4f5fdae7e7b"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "1a4ace8ad70fc3509c52ed67fee11d3b4d22ee3abfa0136d873f52653ea4a66e" => :mojave
    sha256 "e676ae9da3fa8f472c0747a9fb993a6957c2cccceee34d9564e839d0eca59a06" => :high_sierra
  end

  depends_on :xcode => ["10.1", :build]

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
