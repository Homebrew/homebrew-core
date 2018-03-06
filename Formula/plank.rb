class Plank < Formula
  desc "Framework for generating immutable model objects"
  homepage "https://pinterest.github.io/plank/"
  url "https://github.com/pinterest/plank/archive/v1.4.tar.gz"
  sha256 "f5421e7e3790ba6aca62ca7cb150eda8ce74b46713d15e3139e545b125984b01"

  bottle do
    cellar :any_skip_relocation
    sha256 "0adac99e6dc8cc45a9d059c2438a0f6c703e2b3dedeafb79b28244864d91ecc4" => :high_sierra
    sha256 "ee67fc2269b4f4920e6fcbd9311df017a4e2eb9dafe4940e1c1282d77999000b" => :sierra
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
