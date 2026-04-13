class Mark < Formula
  desc "Sync your markdown files with Confluence pages"
  homepage "https://github.com/kovetskiy/mark"
  url "https://github.com/kovetskiy/mark/archive/refs/tags/v16.3.0.tar.gz"
  sha256 "0a0f6f894c555bb99063dfdfd9bb612cb1c3ee2828be7cc0a0b0c9292640482f"
  license "Apache-2.0"
  head "https://github.com/kovetskiy/mark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3fb67bf38b6c3dfd9d017d7e09b3faba8a692b4f98c08eaa57d8c186033741a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3fb67bf38b6c3dfd9d017d7e09b3faba8a692b4f98c08eaa57d8c186033741a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3fb67bf38b6c3dfd9d017d7e09b3faba8a692b4f98c08eaa57d8c186033741a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8c3a72663e576bed76ef2e0e40a8f3a8408cfb6f35725b57be1ae6708fb59c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c2fdba8e2d69baa25c92a5e7d4105c2851714e9e61a98799733939f44aaa82bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aca8d55baf333acd12f6052b898755ac361945d56f7069702382c2e12a5b0a4b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/mark"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mark --version")

    (testpath/"test.md").write <<~MARKDOWN
      # Hello Homebrew
    MARKDOWN

    output = shell_output("#{bin}/mark --config nonexistent.yaml sync 2>&1", 1)
    assert_match "confluence password should be specified", output
  end
end
