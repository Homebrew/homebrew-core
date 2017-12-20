class Dryrun < Formula
  desc ":cloud: Try the demo project of any Android Library"
  homepage "https://github.com/cesarferreira/dryrun/blob/master/README.md"
  url "https://github.com/cesarferreira/dryrun/archive/v1.0.0.tar.gz"
  sha256 "220a07109bc5f4a7ef2561a3f55a01c67de1c4c63c59047d10c811d093e26414"

  depends_on :ruby => "1.9"

  resource "ansi" do
    url "https://rubygems.org/gems/ansi-1.5.0.gem"
    sha256 "5408253274e33d9d27d4a98c46d2998266fd51cba58a7eb9d08f50e57ed23592"
  end

  resource "ast" do
    url "https://rubygems.org/gems/ast-2.3.0.gem"
    sha256 "15d97cf7f3430351a8663f2c5fb7591fb29f700fa28576c46c53b992e912e85e"
  end

  resource "bundler" do
    url "https://rubygems.org/gems/bundler-1.16.0.gem"
    sha256 "084e7ebe90cc5236520ad49d4c5d9f58b19a98751a249070296a5943f88adb74"
  end

  resource "byebug" do
    url "https://rubygems.org/gems/byebug-9.0.6.gem"
    sha256 "60b508d685ecbdd0ce4c8508527e893b27b4461a347564c589b0bd5c8c656ecd"
  end

  resource "coderay" do
    url "https://rubygems.org/gems/coderay-1.1.2.gem"
    sha256 "9efc1b3663fa561ccffada890bd1eec3a5466808ebc711ab1c5d300617d96a97"
  end

  resource "colorize" do
    url "https://rubygems.org/gems/colorize-0.8.1.gem"
    sha256 "0ba0c2a58232f9b706dc30621ea6aa6468eeea120eb6f1ccc400105b90c4798c"
  end

  resource "diff-lcs" do
    url "https://rubygems.org/gems/diff-lcs-1.3.gem"
    sha256 "ea7bf591567e391ef262a7c29edaf87c6205204afb5bb39dfa8f08f2e51282a3"
  end

  resource "highline" do
    url "https://rubygems.org/gems/highline-1.7.8.gem"
    sha256 "795274094fd385bfe45a2ac7b68462b6ba43e21bf311dbdca5225a63dba3c5d9"
  end

  resource "method_source" do
    url "https://rubygems.org/gems/method_source-0.9.0.gem"
    sha256 "f6fd06ba997de0eb6622545b8623a804352c2c9c4a44a362a304bb3d64101277"
  end

  resource "oga" do
    url "https://rubygems.org/gems/oga-1.3.1.gem"
    sha256 "ba876c0f39675041d487c03888f0a43f2fbe1e60fef7f3ae8feb81e4156dd218"
  end

  resource "pry" do
    url "https://rubygems.org/gems/pry-0.11.2.gem"
    sha256 "92fec1c12a43832e49135763c0c44d80aaed8123121a698bce1f65edac8e5e79"
  end

  resource "pry-byebug" do
    url "https://rubygems.org/gems/pry-byebug-3.4.3.gem"
    sha256 "160c63cabf54001d825aecf43b8c356fc8fa7e7ebf24840edc1b615af102023d"
  end

  resource "rake" do
    url "https://rubygems.org/gems/rake-10.5.0.gem"
    sha256 "2b55a1ad44b5c945719d8a97c302a316af770b835187d12143e83069df5a8a49"
  end

  resource "rjb" do
    url "https://rubygems.org/gems/rjb-1.5.5.gem"
    sha256 "8a81557cccf06e06435202cedffe3dcda780a9abe3b803a1057c48165746f2de"
  end

  resource "rspec" do
    url "https://rubygems.org/gems/rspec-3.7.0.gem"
    sha256 "0174cfbed780e42aa181227af623e2ae37511f20a2fdfec48b54f6cf4d7a6404"
  end

  resource "rspec-core" do
    url "https://rubygems.org/gems/rspec-core-3.7.0.gem"
    sha256 "29a78669490cce51effb71693bbb7910b840dbf50fa91041bc30e9bde3ab8495"
  end

  resource "rspec-expectations" do
    url "https://rubygems.org/gems/rspec-expectations-3.7.0.gem"
    sha256 "7e571848a5cbdb1661187d04e5c1f29287ec80fcb5a395f9994836892a3780bb"
  end

  resource "rspec-mocks" do
    url "https://rubygems.org/gems/rspec-mocks-3.7.0.gem"
    sha256 "23f7f0039e17f2841edfb51d678ac9e06c056903a7908db967f5618887f2022c"
  end

  resource "rspec-support" do
    url "https://rubygems.org/gems/rspec-support-3.7.0.gem"
    sha256 "77ec518aeb9d078b7a9db18c84afa51dd877398b1c0336275fb9c803e7c57743"
  end

  resource "ruby-ll" do
    url "https://rubygems.org/gems/ruby-ll-2.1.2.gem"
    sha256 "167fd5254f2dc765d63ca5cfee8806edd14e81069e5f1312f9ac61ee559d3c43"
  end

  def install
    ENV.delete("SDKROOT")
    ENV["GEM_HOME"] = libexec

    resources.each do |r|
      r.verify_download_integrity(r.fetch)
      system "gem", "install", r.cached_download, "--ignore-dependencies",
          "--no-document", "--install-dir", libexec
    end

    system libexec/"bin/bundle", "install", "--local"
    system "gem", "build", "dryrun.gemspec"
    system "gem", "install", "--ignore-dependencies", "dryrun-#{version}.gem"

    libexec.install Dir["*"] - ["bin"]

    env = {
      :BUNDLE_GEMFILE => libexec/"Gemfile",
      :BUNDLE_PATH => libexec,
      :GEM_HOME => libexec,
    }

    (bin/"dryrun").write_env_script(libexec/"bin/dryrun", env)
  end

  test do
    assert_equal "1.0.0\n", shell_output("#{bin}/dryrun -v")
  end
end
