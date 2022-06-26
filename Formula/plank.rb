class Plank < Formula
  desc "Framework for generating immutable model objects"
  homepage "https://pinterest.github.io/plank/"
  url "https://github.com/pinterest/plank/archive/v1.6.tar.gz"
  sha256 "6a233120905ff371b5c06a23b3fc7dd67e96355dd4d992a58ac087db22c500ef"
  license "Apache-2.0"
  head "https://github.com/pinterest/plank.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a91615ae4446513edd3ddb6fe91bcd8ae9768359da3af805ac7154e5a62487a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ba560dc8f11ecdeef3e745cc00a0b7f6cae8074d4cfff100f43227e548c5db7a"
    sha256 cellar: :any_skip_relocation, monterey:       "93cee4a7fa60747f1fc7f7e993d23b2af943bff41184ca681b807cfbc10582e3"
    sha256 cellar: :any_skip_relocation, big_sur:        "ea5dbcccb44df98be951af22f29b81b24bdba7731f88a472708fe7c5bc3d53e3"
    sha256 cellar: :any_skip_relocation, catalina:       "fc6838079a8a975c9bb77d17a050aa722d8446fcf9f62ca9fe09c8822d8651b4"
    sha256 cellar: :any_skip_relocation, mojave:         "04d2dddb094914fa219304fea8f6e5aa3315c2e51b63ef4077fcf25a54c8b268"
  end

  depends_on xcode: ["11.3", :build]

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
