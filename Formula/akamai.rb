class Akamai < Formula
  desc "CLI toolkit for working with Akamai's APIs"
  homepage "https://github.com/akamai/cli"
  url "https://github.com/akamai/cli/archive/0.1.1.tar.gz"
  sha256 "d6548a96249c398546ba70ae83eda1d9172174966ae9586b806db926928843be"

  depends_on "go" => :build
  depends_on "glide" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"

    srcpath = buildpath/"src/github.com/akamai/cli"
    srcpath.install buildpath.children

    cd srcpath do
      system "glide", "install"
      system "go", "build", "-o", bin/"akamai"
    end
  end

  test do
    assert_match "purge\tPurge", shell_output("yes | #{bin}/akamai get purge")
  end
end
