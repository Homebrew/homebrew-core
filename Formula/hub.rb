class Hub < Formula
  desc "Add GitHub support to git on the command-line"
  homepage "https://hub.github.com/"
  url "https://github.com/github/hub/archive/v2.12.4.tar.gz"
  sha256 "82f445505866319c6bbad78cf149afca27c5542e98132cdff2f31c26a700d05a"
  head "https://github.com/github/hub.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f1ea5419a87fa9367a4a81dd26e69d79267b61937a70d890539b12adbef3c535" => :mojave
    sha256 "10ae9e02d6320feb5fb806567abda5c62d0e854c5fd694f308edc470562021a7" => :high_sierra
    sha256 "885e960c1011469d21fe3b9d33e6429e41c0247896da16f275f7cda287478c89" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/github/hub").install buildpath.children
    cd "src/github.com/github/hub" do
      system "make", "install", "prefix=#{prefix}"

      prefix.install_metafiles

      bash_completion.install "etc/hub.bash_completion.sh"
      zsh_completion.install "etc/hub.zsh_completion" => "_hub"
      fish_completion.install "etc/hub.fish_completion" => "hub.fish"
    end
  end

  test do
    system "git", "init"
    %w[haunted house].each { |f| touch testpath/f }
    system "git", "add", "haunted", "house"
    system "git", "commit", "-a", "-m", "Initial Commit"
    assert_equal "haunted\nhouse", shell_output("#{bin}/hub ls-files").strip
  end
end
