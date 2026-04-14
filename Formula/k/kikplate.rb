class Kikplate < Formula
  desc "Command-line interface for the Kikplate plate registry"
  homepage "https://github.com/kikplate/kikplate"
  url "https://github.com/kikplate/kikplate/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "208b8c2ddc22de019394b4972adad831f254227abc24d0f9da50a8db5c5b7b6d"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    cd "cli" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "."
    end
  end

  test do
    assert_match "Kikplate CLI", shell_output("#{bin}/kikplate --help")
  end
end
