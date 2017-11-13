class Dryrun < Formula
  desc ":cloud: Try the demo project of any Android Library"
  homepage "https://github.com/cesarferreira/dryrun/blob/master/README.md"
  url "https://github.com/cesarferreira/dryrun/archive/v1.0.0.tar.gz"
  sha256 "220a07109bc5f4a7ef2561a3f55a01c67de1c4c63c59047d10c811d093e26414"

  depends_on :ruby => "1.9"

  resource "bundler" do
    url "https://rubygems.org/gems/bundler-1.16.0.gem"
    sha256 "084e7ebe90cc5236520ad49d4c5d9f58b19a98751a249070296a5943f88adb74"
  end

  resource "colorize" do
    url "https://rubygems.org/gems/colorize-0.8.1.gem"
    sha256 "0ba0c2a58232f9b706dc30621ea6aa6468eeea120eb6f1ccc400105b90c4798c"
  end

  resource "oga" do
    url "https://rubygems.org/gems/oga-2.11.gem"
    sha256 "b84506db98f68054c17b5c5d940cb371e840a46b54e422347e23b34d2ee7b37d"
  end

  resource "highline" do
    url "https://rubygems.org/gems/highline-1.7.8.gem"
    sha256 "795274094fd385bfe45a2ac7b68462b6ba43e21bf311dbdca5225a63dba3c5d9"
  end

  resource "rjb" do
    url "https://rubygems.org/gems/rjb-1.5.5.gem"
    sha256 "8a81557cccf06e06435202cedffe3dcda780a9abe3b803a1057c48165746f2de"
  end

  def install
    ENV["GEM_HOME"] = libexec
    resources.each do |r|
      r.verify_download_integrity(r.fetch)
      system "gem", "install", r.cached_download, "--no-document",
        "--install-dir", libexec
    end
    system "gem", "build", "dryrun.gemspec"
    system "gem", "install", "--ignore-dependencies", "dryrun-#{version}.gem"
    bin.install libexec/"bin/dryrun"
    bin.env_script_all_files(libexec/"bin", :GEM_HOME => ENV["GEM_HOME"])
  end

  test do
    assert_equal "1.0.0\n", shell_output("#{bin}/dryrun -v")
  end
end
