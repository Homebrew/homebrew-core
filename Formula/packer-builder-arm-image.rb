class PackerBuilderArmImage < Formula
  desc "Packer plugin for ARM images"
  homepage "https://github.com/solo-io/packer-builder-arm-image"
  url "https://github.com/solo-io/packer-builder-arm-image/archive/refs/tags/v0.1.6.tar.gz"
  sha256 "73160cb96ca6ed059c89deab73df2647e4b96399084b98339a185aa574e26922"
  license "Apache-2.0"
  head "https://github.com/solo-io/packer-builder-arm-image.git"

  depends_on "go" => :build
  depends_on "packer"

  def install
    system "go", "build", *std_go_args, "-mod=vendor"
  end

  test do
    (testpath/"kali.json").write <<~EOS
      {
        "variables": {
        },
        "builders": [
          {
            "type": "arm-image",
            "iso_url": "https://images.offensive-security.com/arm-images/kali-linux-2020.2a-rpi3-nexmon.img.xz",
            "iso_checksum": "sha256:ea6e4ffc142a9216de18119ff97dcb8741f7a69d28ba947eb5bb61b5e5340a0c"
          }
        ],
        "provisioners": [
          {
            "type": "shell",
            "inline": [
              "apt-get update && apt-get install -y golang"
            ]
          }
        ]
      }
    EOS
    system "packer", "validate", "kali.json"
  end
end
