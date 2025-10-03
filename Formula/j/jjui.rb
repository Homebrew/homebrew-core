class Jjui < Formula
  desc "TUI for interacting with the Jujutsu version control system"
  homepage "https://github.com/idursun/jjui"
  url "https://github.com/idursun/jjui/archive/refs/tags/v0.9.3.tar.gz"
  sha256 "799a66c6ec044dcfa6cfa538b6356ed4affac6cabba8dd487db77fe11d5a5421"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d4f8d38cf1b123d4c8f2a4357779aea4a010302b5fe941654a87a8a6635afe5f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "019d7b1c093451352bf55bb4e7d3eeb150470f4f8e6819b9d957c3a848520074"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "019d7b1c093451352bf55bb4e7d3eeb150470f4f8e6819b9d957c3a848520074"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "019d7b1c093451352bf55bb4e7d3eeb150470f4f8e6819b9d957c3a848520074"
    sha256 cellar: :any_skip_relocation, sonoma:        "c56e3a4632d45484da4f8cd5df1e099a6c5981d05204df7c1e289c30bbbf466b"
    sha256 cellar: :any_skip_relocation, ventura:       "c56e3a4632d45484da4f8cd5df1e099a6c5981d05204df7c1e289c30bbbf466b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5dfb14e2fcb913d694e79eff65b78cf38c3ba7c56944456c816baf86c5109784"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6cb58f4aa28920dc98dd937ab3c0b594db509d2335a8084e91358fe297ec1852"
  end

  depends_on "go" => :build
  depends_on "jj"

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/jjui"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jjui -version")
    assert_match "Error: There is no jj repo in", shell_output("#{bin}/jjui 2>&1", 1)
  end
end
