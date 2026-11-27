class PodcastDl < Formula
  desc "CLI for downloading and archiving podcasts"
  homepage "https://github.com/lightpohl/podcast-dl"
  url "https://registry.npmjs.org/podcast-dl/-/podcast-dl-12.1.7.tgz"
  sha256 "ebcd417e6ee2656aaef72438798cbc36069f1528f11dc65f5c100261df15f1a4"
  license "MIT"
  head "https://github.com/lightpohl/podcast-dl.git", branch: "main"

  bottle do
    manifest_sha256 "b413327fdcab9e53843d695b4fa505373dc14a7550931a1e7649530280555e8e"
    sha256 cellar: :any_skip_relocation, all: "1d9cfb60005efdf409fba9ed91d173a29abeaf89108e13b98e197480c8bb1691"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"feed.xml").write <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <rss version="2.0">
        <channel>
          <title>Homebrew Test Podcast</title>
          <link>https://example.com/podcast</link>
          <description>Fixture for formula testing.</description>
          <item>
            <title>Episode One</title>
            <guid>episode-1</guid>
            <enclosure url="https://example.com/episode.mp3" type="audio/mpeg" length="1"/>
          </item>
        </channel>
      </rss>
    XML

    assert_match "Homebrew Test Podcast", shell_output("#{bin}/podcast-dl --file feed.xml --info")
  end
end
