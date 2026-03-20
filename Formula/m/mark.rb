class Mark < Formula
  desc "Sync your markdown files with Confluence pages"
  homepage "https://github.com/kovetskiy/mark"
  url "https://github.com/kovetskiy/mark/archive/refs/tags/v15.4.0.tar.gz"
  sha256 "dbe2fe89e545a5bb3c958bbfb6f8121eb9a4c073574f6fe7e1cbb252106a2859"
  license "Apache-2.0"
  head "https://github.com/kovetskiy/mark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "51b947bad8e1db8e433d8d4b3a9318cf7e8a665efb5096fa3f29eb70d714f42b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51b947bad8e1db8e433d8d4b3a9318cf7e8a665efb5096fa3f29eb70d714f42b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51b947bad8e1db8e433d8d4b3a9318cf7e8a665efb5096fa3f29eb70d714f42b"
    sha256 cellar: :any_skip_relocation, sonoma:        "37afa062ef7ee811a966930bc17f646ad50a99cea99d61763774bccc07818134"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8e028ab0a2cb588f1b52a4b10e33618062c47370d9a1eb204b40b390f2413be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3024ddee1d7fef1b297bade38277d6823f131624a350f567a77c3adcd80c54b7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version} -X main.commit=#{tap.user}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mark --version")

    (testpath/"test.md").write <<~MARKDOWN
      # Hello Homebrew
    MARKDOWN

    output = shell_output("#{bin}/mark --config nonexistent.yaml sync 2>&1", 1)
    assert_match "FATAL confluence password should be specified", output
  end
end
