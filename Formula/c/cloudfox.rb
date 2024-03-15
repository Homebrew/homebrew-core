class Cloudfox < Formula
  desc "Automating situational awareness for cloud penetration tests"
  homepage "https://github.com/BishopFox/cloudfox"
  url "https://github.com/BishopFox/cloudfox/archive/refs/tags/v1.13.4.tar.gz"
  sha256 "599ec6f7d341e973cc0a72b03b62955c9b75d3cf503dfb23eab51894afa817a9"
  license "MIT"
  head "https://github.com/BishopFox/cloudfox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7a9193c152f5ed7be68ce240d970f75d3e0c898259dabf7e1641eba38fcca867"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3c71d58f65a0f25eed8995ccbc03b56da7372992efce27bf9ab30b92dfda87e9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6aa00b248eeadd42921c109ceccf753d26ebb61a6b3b11d6aca7e40dacfa172f"
    sha256 cellar: :any_skip_relocation, sonoma:         "fcefa470677772ed272edb039e9f1ff46a57e165fc1dc256970a1195bc455a8a"
    sha256 cellar: :any_skip_relocation, ventura:        "c40a846957ac574dbf2d59f93f1298fb8a2fcc80908abc0beeb2d389cda91b0f"
    sha256 cellar: :any_skip_relocation, monterey:       "66d58f2d00e0ecc2cf387d668bb85d94fd3f43102c3eb21c2c56e3a7549e168f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19f990bf6673b32cfa49413c098ca199c44b159870726b0b408a4f9c0250302e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"cloudfox", "completion")
  end

  test do
    ENV["AWS_ACCESS_KEY_ID"] = "test"
    ENV["AWS_SECRET_ACCESS_KEY"] = "test"

    output = shell_output("#{bin}/cloudfox aws principals 2>&1")
    assert_match "Could not get caller's identity", output

    assert_match version.to_s, shell_output("#{bin}/cloudfox --version")
  end
end
