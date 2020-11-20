class Gopls < Formula
  desc "Language server for the Go language"
  homepage "https://github.com/golang/tools/tree/master/gopls"
  url "https://github.com/golang/tools/archive/gopls/v0.5.3.tar.gz"
  sha256 "f3a1c142f42c7e9cff62ec9a1a6e41e59305c7519735839ecedccf17597ae00e"
  license "BSD-3-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "023ac272fd82dd6b22ad86636eab63d3cb536b8e3cb95740b56495abcd2dda39" => :big_sur
    sha256 "f8ee59eeebfcf3d7016ef0940a1c167bb5a133684e708a907995b2d2966b000b" => :catalina
    sha256 "2bb0be3febc55e3908c4d6bba6ad10ab34f3724b243435ecdeee6c1d8dc8afbd" => :mojave
  end

  depends_on "go" => :build

  def install
    cd "gopls" do
      system "go", "build", *std_go_args
    end
  end

  test do
    output = shell_output("#{bin}/gopls api-json")
    output = JSON.parse(output)

    assert_equal "gopls.generate", output["Commands"][0]["Command"]
    assert_equal "false", output["Options"]["Debugging"][0]["Default"]
  end
end
