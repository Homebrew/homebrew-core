class Comtrya < Formula
  desc "Configuration and dotfile management tool"
  homepage "https://comtrya.dev"
  url "https://github.com/comtrya/comtrya/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "7bbd6ac04314e2dd541d8104908a2e8991a7489daab5563d01d28a3e48c08350"
  license "MIT"
  head "https://github.com/comtrya/comtrya.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d47418f399155160faedb236b13d882ae55200aa9cc211e4f5ad4c77013aec29"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46bf7dfc1bc293ec74fc38268c4ea93141cc02e9da597659c9b7211e31b1d7ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a8832ef28773fb65085509c65d978081f9d1fd773ddbcb4b56449cbeb94a87f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9b68a181a0d187ff39d38f05615a38fb5c238130c609deb71f382e0a7c790a77"
    sha256 cellar: :any_skip_relocation, sonoma:        "2beda410c50174b01333927b00eece60fc67fb8d88af2306497f6771b7327155"
    sha256 cellar: :any_skip_relocation, ventura:       "91d872c1955cdba479855aa1a57cd647e91d3ccd19585eab397221619e6d17e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "feefd9e00ca885fbb8b67fa3ad298ff77d90beb29f458780ed4f2e50e7882795"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e52d28d153e028d22f1e74375a63f0bd43281bd6370f65cbe0d35305e79c4c2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "app")

    generate_completions_from_executable(bin/"comtrya", "gen-completions")
  end

  test do
    assert_match "comtrya #{version}", shell_output("#{bin}/comtrya --version")

    resource "testmanifest" do
      url "https://raw.githubusercontent.com/comtrya/comtrya/refs/heads/main/examples/onlyvariants/main.yaml"
      sha256 "0715e12cbbb95c8d6c36bb02ae4b49f9fa479e2f28356b8c1f3b5adfb000b93f"
    end

    resource("testmanifest").stage do
      system bin/"comtrya", "-d", "main.yaml", "apply"
    end
  end
end
