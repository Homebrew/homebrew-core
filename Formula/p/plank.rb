class Plank < Formula
  desc "Framework for generating immutable model objects"
  homepage "https://pinterest.github.io/plank/"
  url "https://github.com/pinterest/plank/archive/refs/tags/v1.6.tar.gz"
  sha256 "6a233120905ff371b5c06a23b3fc7dd67e96355dd4d992a58ac087db22c500ef"
  license "Apache-2.0"
  head "https://github.com/pinterest/plank.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "ac1ceb4106e80992e3660b5952f11d6a0e29c1269ebbef672f647cf752d26e20"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "902d73cd939a2dabe044db2f5023ba45c1c5ac8c83e77f650110fd167d03dd04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1c300759e15cbfe318181f9a32a7642f297c72f20b6e5503e90d6ffe72dd9f04"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8e8373c6eb34b0b7d1e82233fab34cec1a4bd1362daf8b85253367ab5e1373e9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a91615ae4446513edd3ddb6fe91bcd8ae9768359da3af805ac7154e5a62487a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ba560dc8f11ecdeef3e745cc00a0b7f6cae8074d4cfff100f43227e548c5db7a"
    sha256 cellar: :any_skip_relocation, sonoma:         "4acb07fc0f33ab110982572fd68f70b14af77fc6765feb5b02d0c50652238225"
    sha256 cellar: :any_skip_relocation, ventura:        "14075f5bdbf249f033c85087b7e65acc1f9b984b3a4d79f72bbb34485bebb5b2"
    sha256 cellar: :any_skip_relocation, monterey:       "93cee4a7fa60747f1fc7f7e993d23b2af943bff41184ca681b807cfbc10582e3"
    sha256 cellar: :any_skip_relocation, big_sur:        "ea5dbcccb44df98be951af22f29b81b24bdba7731f88a472708fe7c5bc3d53e3"
    sha256 cellar: :any_skip_relocation, catalina:       "fc6838079a8a975c9bb77d17a050aa722d8446fcf9f62ca9fe09c8822d8651b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "69d69e6bee1ede7fecdb840ac121ce0d61d72d1d0218e501ca0bcea06c1a3d89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea941cd9c41a8ac9cb53678eaf17d5f0eeb04930758bcac1be793d17d60fe861"
  end

  depends_on xcode: ["11.3", :build]

  uses_from_macos "swift" => :build

  # fix build failures, upstream pr ref, https://github.com/pinterest/plank/pull/301
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/plank/1.6.patch"
    sha256 "782de4c235f03d5997c88506cd02e1cf97e5793fecf0e3bbff25d62f5393412a"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"pin.json").write <<~JSON
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
    JSON
    system bin/"plank", "--lang", "objc,flow", "--output_dir", testpath, "pin.json"
    assert_path_exists testpath/"Pin.h", "[ObjC] Generated file does not exist"
    assert_path_exists testpath/"PinType.js", "[Flow] Generated file does not exist"
  end
end
