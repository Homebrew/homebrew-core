class AsperaCli < Formula
  desc "Command-line interface for IBM Aspera products"
  homepage "https://github.com/IBM/aspera-cli"
  url "https://github.com/IBM/aspera-cli.git",
      tag:      "v4.28.0",
      revision: "a72c8cbe951da82fbb06041dbedee15be4e0b3bb"
  license "Apache-2.0"

  depends_on "ruby"

  # List with `gem install --explain aspera-cli -v #{version}`
  resource "rexml" do
    url "https://rubygems.org/downloads/rexml-3.4.4.gem"
    sha256 "19e0a2c3425dfbf2d4fc1189747bdb2f849b6c5e74180401b15734bc97b5d142"
  end

  resource "xml-simple" do
    url "https://rubygems.org/downloads/xml-simple-1.1.9.gem"
    sha256 "d21131e519c86f1a5bc2b6d2d57d46e6998e47f18ed249b25cad86433dbd695d"
  end

  resource "websocket" do
    url "https://rubygems.org/downloads/websocket-1.2.11.gem"
    sha256 "b7e7a74e2410b5e85c25858b26b3322f29161e300935f70a0e0d3c35e0462737"
  end

  resource "webrick" do
    url "https://rubygems.org/downloads/webrick-1.9.2.gem"
    sha256 "beb4a15fc474defed24a3bda4ffd88a490d517c9e4e6118c3edce59e45864131"
  end

  resource "connection_pool" do
    url "https://rubygems.org/downloads/connection_pool-3.0.2.gem"
    sha256 "33fff5ba71a12d2aa26cb72b1db8bba2a1a01823559fb01d29eb74c286e62e0a"
  end

  resource "net-http-persistent" do
    url "https://rubygems.org/downloads/net-http-persistent-4.0.8.gem"
    sha256 "ef3de8319d691537b329053fae3a33195f8b070bbbfae8bf1a58c796081960e6"
  end

  resource "base64" do
    url "https://rubygems.org/downloads/base64-0.3.0.gem"
    sha256 "27337aeabad6ffae05c265c450490628ef3ebd4b67be58257393227588f5a97b"
  end

  resource "aws-eventstream" do
    url "https://rubygems.org/downloads/aws-eventstream-1.4.1.gem"
    sha256 "ceb6a99c61df4bb00344e54aed0351574beca24f87a0d1487d1d2ed80929ce96"
  end

  resource "aws-sigv4" do
    url "https://rubygems.org/downloads/aws-sigv4-1.12.1.gem"
    sha256 "6973ff95cb0fd0dc58ba26e90e9510a2219525d07620c8babeb70ef831826c00"
  end

  resource "vault" do
    url "https://rubygems.org/downloads/vault-0.20.1.gem"
    sha256 "169cede8b9ea5f21c975ea92f7618c0d777d9d983afc06f2ddd39b3dd571d660"
  end

  resource "tty-cursor" do
    url "https://rubygems.org/downloads/tty-cursor-0.7.1.gem"
    sha256 "79534185e6a777888d88628b14b6a1fdf5154a603f285f80b1753e1908e0bf48"
  end

  resource "tty-spinner" do
    url "https://rubygems.org/downloads/tty-spinner-0.9.3.gem"
    sha256 "0e036f047b4ffb61f2aa45f5a770ec00b4d04130531558a94bfc5b192b570542"
  end

  resource "unicode-emoji" do
    url "https://rubygems.org/downloads/unicode-emoji-4.3.0.gem"
    sha256 "11c02fa73290378c066bb0562cd4c87d8e1b706fbbe0059ca12746a4244de8ce"
  end

  resource "unicode-display_width" do
    url "https://rubygems.org/downloads/unicode-display_width-3.3.0.gem"
    sha256 "4b7aa66a4b11db50f6f7e98411215cd0dd10eaecb665d36eec5bcacb3fa0b613"
  end

  resource "terminal-table" do
    url "https://rubygems.org/downloads/terminal-table-4.0.0.gem"
    sha256 "f504793203f8251b2ea7c7068333053f0beeea26093ec9962e62ea79f94301d2"
  end

  resource "rubyzip" do
    url "https://rubygems.org/downloads/rubyzip-3.7.0.gem"
    sha256 "65c19294da75297a939006f3516deacc33185fbd721ff1954f7a231db6d3e121"
  end

  resource "ruby-progressbar" do
    url "https://rubygems.org/downloads/ruby-progressbar-1.13.0.gem"
    sha256 "80fc9c47a9b640d6834e0dc7b3c94c9df37f08cb072b7761e4a71e22cff29b33"
  end

  resource "rainbow" do
    url "https://rubygems.org/downloads/rainbow-3.1.1.gem"
    sha256 "039491aa3a89f42efa1d6dec2fc4e62ede96eb6acd95e52f1ad581182b79bc6a"
  end

  resource "logger" do
    url "https://rubygems.org/downloads/logger-1.7.0.gem"
    sha256 "196edec7cc44b66cfb40f9755ce11b392f21f7967696af15d274dde7edff0203"
  end

  resource "net-ssh" do
    url "https://rubygems.org/downloads/net-ssh-7.3.10.gem"
    sha256 "8b54591acc8f9dbb63cd906add66a816c302f950cf92137b14155e809abea472"
  end

  resource "timeout" do
    url "https://rubygems.org/downloads/timeout-0.6.1.gem"
    sha256 "78f57368a7e7bbadec56971f78a3f5ecbcfb59b7fcbb0a3ed6ddc08a5094accb"
  end

  resource "net-protocol" do
    url "https://rubygems.org/downloads/net-protocol-0.4.0.gem"
    sha256 "f9f90c8c6f64794a45160bf422177a336db12809de3beeeaa26b88fcd2e8c853"
  end

  resource "net-smtp" do
    url "https://rubygems.org/downloads/net-smtp-0.5.2.gem"
    sha256 "35103cc04d6b2d94632f9928ede07483c24b70b9c0db1f231fea43909b678f3c"
  end

  resource "mime-types-data" do
    url "https://rubygems.org/downloads/mime-types-data-3.2026.1103.gem"
    sha256 "cda7af94d895f1fd33e000acea800e6ed31e4c861e3d6c1a27c8b74f9e44dc64"
  end

  resource "mime-types" do
    url "https://rubygems.org/downloads/mime-types-3.7.0.gem"
    sha256 "dcebf61c246f08e15a4de34e386ebe8233791e868564a470c3fe77c00eed5e56"
  end

  resource "marcel" do
    url "https://rubygems.org/downloads/marcel-1.2.1.gem"
    sha256 "1678e9360e32f9eafa917c80029e2f6d10b2715c66a4b87b6d0da9b9cd1f859f"
  end

  resource "jwt" do
    url "https://rubygems.org/downloads/jwt-3.3.0.gem"
    sha256 "44cc34fbc341c148233cf66641522b4bce0dfb1ce55e8073f05c56f44f4ee546"
  end

  resource "simpleidn" do
    url "https://rubygems.org/downloads/simpleidn-0.3.0.gem"
    sha256 "12ca730bed2f3db04d11e9bfd1bca3e11fb37f55b21eb2e9793fb5814bf54d03"
  end

  resource "regexp_parser" do
    url "https://rubygems.org/downloads/regexp_parser-2.13.1.gem"
    sha256 "5aedb6b7c35688f51e86eef17a15374dfd287c83f4ca644b2c5f3ec50a33b44b"
  end

  resource "hana" do
    url "https://rubygems.org/downloads/hana-1.3.7.gem"
    sha256 "5425db42d651fea08859811c29d20446f16af196308162894db208cac5ce9b0d"
  end

  resource "bigdecimal" do
    url "https://rubygems.org/downloads/bigdecimal-4.1.3.gem"
    sha256 "61ebe1e5e559bdc3cc6f2c0ee7f427321fc838f59611c294356eb04d6e21cf66"
  end

  resource "json_schemer" do
    url "https://rubygems.org/downloads/json_schemer-2.5.0.gem"
    sha256 "2f01fb4cce721a4e08dd068fc2030cffd0702a7f333f1ea2be6e8991f00ae396"
  end

  resource "jmespath" do
    url "https://rubygems.org/downloads/jmespath-1.6.2.gem"
    sha256 "238d774a58723d6c090494c8879b5e9918c19485f7e840f2c1c7532cf84ebcb1"
  end

  resource "json" do
    url "https://rubygems.org/downloads/json-3.1.0.gem"
    sha256 "3ce7ccf8fde58960177a3a756c31f292a4c1e1dedee884547096a5b0604e3bd8"
  end

  resource "execjs" do
    url "https://rubygems.org/downloads/execjs-2.10.2.gem"
    sha256 "466cf2b49e50c0cfdff8fdb88a7a983dfab7ac0f6185c317ccb434a75c224c88"
  end

  resource "csv" do
    url "https://rubygems.org/downloads/csv-3.3.7.gem"
    sha256 "15a3f16f6628da8664d455eb634e7f22031bcf53044923caf56975109e71b9f8"
  end

  resource "chunky_png" do
    url "https://rubygems.org/downloads/chunky_png-1.4.0.gem"
    sha256 "89d5b31b55c0cf4da3cf89a2b4ebc3178d8abe8cbaf116a1dba95668502fdcfe"
  end

  def install
    ENV["GEM_HOME"] = libexec

    resources.each do |r|
      system "gem", "install", r.cached_download, "--ignore-dependencies", "--no-document", "--install-dir", libexec
    end
    system "gem", "build", "aspera-cli.gemspec"
    system "gem", "install", "--ignore-dependencies", "--no-document", "aspera-cli-#{version}.gem"

    rm libexec.glob("extensions/*/*/*/mkmf.log")

    bin.install libexec.glob("bin/{ascli,asession}")
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ascli --version")

    output = shell_output("#{bin}/ascli config echo @json:'{\"hello\":\"world\"}' --format=json")
    assert_equal({ "hello" => "world" }, JSON.parse(output))
    assert_path_exists testpath/".aspera/ascli/config.yaml"
  end
end
