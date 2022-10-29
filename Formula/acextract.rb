class Acextract < Formula
  desc "Tool to list and extract content from Assets.car file"
  homepage "https://github.com/bartoszj/acextract"
  # pull from git tag to get submodules
  url "https://github.com/bartoszj/acextract.git",
    tag:      "2.2",
    revision: "df3b018d53cd4b684a5f6d63535dcc4156be1a97"
  license "MIT"

  depends_on xcode: :build
  uses_from_macos "ruby" => :build

  resource "xcpretty" do
    url "https://rubygems.org/downloads/xcpretty-0.3.0.gem"
    sha256 "75c7cc577be3527e7663ca627cbeb47613904c3a44f34cca3a92d202053e04f7"
  end

  def install
    ENV["GEM_HOME"] = libexec

    resources.each do |r|
      r.fetch
      system "gem", "install", r.cached_download, "--no-document",
                    "--install-dir", libexec
    end

    system "make", "build"
    bin.install "acextract"
  end

  test do
    car = "/System/Applications/App Store.app/Contents/Resources/Assets.car"
    stdout = shell_output bin/"acextract --input '#{car}' --list"
    assert_match "AppIcon", stdout
  end
end
