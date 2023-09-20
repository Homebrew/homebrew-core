class Datacontract < Formula
  desc "Manage your datacontract.yaml files"
  homepage "https://cli.datacontract.com/"
  url "https://github.com/datacontract/cli.git", tag: "v0.1.1", revision: "173cefbe0bb400de6e83a9b5c9ce27179d9d49e4"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-o", bin/"datacontract"
  end

  test do
    assert_match "datacontract version v0.1.1", shell_output("#{bin}/datacontract -v")
  end
end
