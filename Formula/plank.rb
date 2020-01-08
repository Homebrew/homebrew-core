class Plank < Formula
  desc "Framework for generating immutable model objects"
  homepage "https://pinterest.github.io/plank/"
  url "https://github.com/pinterest/plank/archive/v1.6.tar.gz"
  sha256 "6a233120905ff371b5c06a23b3fc7dd67e96355dd4d992a58ac087db22c500ef"

  bottle do
    cellar :any_skip_relocation
    sha256 "1a4ace8ad70fc3509c52ed67fee11d3b4d22ee3abfa0136d873f52653ea4a66e" => :mojave
    sha256 "e676ae9da3fa8f472c0747a9fb993a6957c2cccceee34d9564e839d0eca59a06" => :high_sierra
  end

  depends_on :xcode => ["11.3", :build]

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
