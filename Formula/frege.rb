class Frege < Formula
  desc "Non-strict, functional programming language in the spirit of Haskell"
  homepage "https://github.com/Frege/frege/"
  url "https://github.com/Frege/frege/releases/download/3.24public/frege3.24.405.jar"
  sha256 "f5a6e40d1438a676de85620e3304ada4760878879e02dbb7c723164bd6087fc4"
  license "BSD-3-Clause"
  revision 3

  # The jar file versions in the GitHub release assets are often different
  # than the tag version, so we can't identify the latest version from the tag
  # alone. This `strategy` block fetches the separate asset list HTML for the
  # "latest" release and matches versions in the jar filenames.
  livecheck do
    url "https://github.com/Frege/frege/releases/latest"
    regex(/href=.*?frege[._-]?(\d+(?:\.\d+)+)\.jar/i)
    strategy :header_match do |headers, regex|
      next if headers["location"].blank?

      # Identify the latest tag from the response's `location` header
      latest_tag = File.basename(headers["location"])
      next if latest_tag.blank?

      # Fetch the assets list HTML for the latest tag and match within it
      assets_page = Homebrew::Livecheck::Strategy.page_content(
        @url.sub(%r{/releases/?.+}, "/releases/expanded_assets/#{latest_tag}"),
      )
      assets_page[:content]&.scan(regex)&.map { |match| match[0] }
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "28f3c0d702b145adb8d615507d492ce37bf7309fde2dcda48b47397c2a387ffa"
  end

  depends_on "openjdk"

  def install
    libexec.install "frege#{version}.jar"
    bin.write_jar_script libexec/"frege#{version}.jar", "fregec"
  end

  test do
    (testpath/"test.fr").write <<~EOS
      module Hello where

      greeting friend = "Hello, " ++ friend ++ "!"

      main args = do
          println (greeting "World")
    EOS
    system bin/"fregec", "-d", testpath, "test.fr"
    output = shell_output "#{Formula["openjdk"].bin}/java -Xss1m -cp #{testpath}:#{libexec}/frege#{version}.jar Hello"
    assert_equal "Hello, World!\n", output
  end
end
