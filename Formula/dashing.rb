class Dashing < Formula
  desc "Generate Dash documentation from HTML files"
  homepage "https://github.com/technosophos/dashing"
  url "https://github.com/technosophos/dashing/archive/0.3.0.tar.gz"
  sha256 "f6569f3df80c964c0482e7adc1450ea44532d8da887091d099ce42a908fc8136"

  depends_on "glide" => :build
  depends_on "go" => :build

  # use ruby docs just as dummy documentation to test with
  resource "ruby_docs_tarball" do
    url "https://ruby-doc.org/downloads/ruby_2_5_0_core_rdocs.tgz"
    sha256 "219e171641e979a5c8dee1b63347a1a26b94ba648aec96f7e6ed915d12bcaa15"
  end

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"

    (buildpath/"src/github.com/technosophos/dashing").install buildpath.children
    cd "src/github.com/technosophos/dashing" do
      system "glide", "install"
      ldflags = "-X main.version=#{version}"
      system "go", "build", "-o", "#{bin}/dashing", "-ldflags", ldflags, "dashing.go"
      prefix.install_metafiles
    end
  end

  test do
    testpath.install resource("ruby_docs_tarball")

    # make sure that dashing creates its settings file and then builds
    # an actual docset for Dash
    system "#{bin}/dashing", "create"
    assert_predicate testpath/"dashing.json", :exist?
    system "#{bin}/dashing", "build", "."
    assert_predicate testpath/"dashing.docset", :exist?
  end
end
