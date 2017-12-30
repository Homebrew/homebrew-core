class Braid < Formula
  desc "Simple tool to help track vendor branches in a Git repository"
  homepage "https://cristibalan.github.io/braid/"
  url "https://github.com/cristibalan/braid.git",
      :tag => "v1.0.22",
      :revision => "3339d2cce298bec80152223ef782f2ad45e881ec"

  bottle do
    cellar :any_skip_relocation
    sha256 "713a6ff10de29a14ab22cf26f43ad77d2cda7deb3c3d10cad6a0cfcd3aa6f71a" => :high_sierra
    sha256 "d0b798af1cad15297ad081022dac157fe38d5e8fe444b6b38ce6b8c05b6c8938" => :sierra
    sha256 "0e3bece1844845d7eefb05837e3b673050de48085fb6c72603fe1300e3a10f11" => :el_capitan
  end

  depends_on :ruby => "2.2"

  resource "arrayfields" do
    url "https://rubygems.org/gems/arrayfields-4.9.2.gem"
    sha256 "1593f0bac948e24aa5e5099b7994b0fb5da69b6f29a82804ccf496bc125de4ab"
  end

  resource "chronic" do
    url "https://rubygems.org/gems/chronic-0.10.2.gem"
    sha256 "766f2fcce6ac3cc152249ed0f2b827770d3e517e2e87c5fba7ed74f4889d2dc3"
  end

  resource "fattr" do
    url "https://rubygems.org/gems/fattr-2.3.0.gem"
    sha256 "0430a798270a7097c8c14b56387331808b8d9bb83904ba643b196c895bdf5993"
  end

  resource "main" do
    url "https://rubygems.org/gems/main-6.2.2.gem"
    sha256 "af04ee3eb4b7455eb5ab17e98ab86b0dad8b8420ad3ae605313644a4c6f49675"
  end

  resource "map" do
    url "https://rubygems.org/gems/map-6.6.0.gem"
    sha256 "153a6f384515b14085805f5839d318f9d3c9dab676f341340fa4300150373cbc"
  end

  def install
    ENV["GEM_HOME"] = libexec
    resources.each do |r|
      r.verify_download_integrity(r.fetch)
      system "gem", "install", r.cached_download, "--ignore-dependencies",
             "--no-document", "--install-dir", libexec
    end
    system "gem", "build", "braid.gemspec"
    system "gem", "install", "--ignore-dependencies", "braid-#{version}.gem"
    bin.install libexec/"bin/braid"
    bin.env_script_all_files(libexec/"bin", :GEM_HOME => ENV["GEM_HOME"])
  end

  test do
    system "git", "init"
    (testpath/"README").write "Testing"
    (testpath/".gitignore").write "Library"
    system "git", "add", "README", ".gitignore"
    system "git", "commit", "-m", "Initial commit"
    output = shell_output("#{bin}/braid add https://github.com/cristibalan/braid.git")
    assert_match "Braid: Added mirror at '", output
    assert_match "braid (", shell_output("#{bin}/braid status")
  end
end
