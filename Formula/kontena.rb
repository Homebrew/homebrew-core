class Kontena < Formula
  desc "Command-line client for Kontena container orchestration platform"
  homepage "https://kontena.io/"
  head "https://github.com/kontena/kontena.git"
  revision 1

  stable do
    url "https://github.com/kontena/kontena.git",
        :tag => "v1.4.2",
        :revision => "ead10ec4191a101769095b5fc7c3eeabaa05c621"

    resource "addressable" do
      url "https://rubygems.org/gems/addressable-2.5.2.gem"
      sha256 "73771ea960b3900d96e6b3729bd203e66f387d0717df83304411bf37efd7386e"
    end

    resource "clamp" do
      url "https://rubygems.org/gems/clamp-1.1.2.gem"
      sha256 "f338133cf34d9a2b8d51d5b545f29c1455e5a3c631b62a4c19504ad50eb9a250"
    end

    resource "equatable" do
      url "https://rubygems.org/gems/equatable-0.5.0.gem"
      sha256 "fdc8669f9bdc993be5cb6c08ec86343a7e87756e33c68ff5f63dfaa9e44f55ea"
    end

    resource "excon" do
      url "https://rubygems.org/gems/excon-0.49.0.gem"
      sha256 "1fb00ffeae85bb1d81ea0b61a5d88df8593cec1643a5f32e637d5148097bad4a"
    end

    resource "hash_validator" do
      url "https://rubygems.org/gems/hash_validator-0.7.1.gem"
      sha256 "0e56f722a02cd0ef6f05ae89c83310a8042f063c80d69ef4a612e0043998145a"
    end

    resource "hitimes" do
      url "https://rubygems.org/gems/hitimes-1.2.6.gem"
      sha256 "5939da5baf4bed890b481d77dc37d481297d0f06f1d2569f4c5c9a2112144218"
    end

    resource "kontena-plugin-cloud" do
      url "https://rubygems.org/gems/kontena-plugin-cloud-1.2.0.gem"
      sha256 "792132467e5c44e168dd679a49b68186da454f2509b79f3be8f3f6d341237ec1"
    end

    resource "kontena-websocket-client" do
      url "https://rubygems.org/gems/kontena-websocket-client-0.1.1.gem"
      sha256 "692804a448d4ac6474d5091c5b74278f5f2f0efd9b2616ebd9a415a18e0f3d96"
    end

    resource "launchy" do
      url "https://rubygems.org/gems/launchy-2.4.3.gem"
      sha256 "42f52ce12c6fe079bac8a804c66522a0eefe176b845a62df829defe0e37214a4"
    end

    resource "liquid" do
      url "https://rubygems.org/gems/liquid-4.0.0.gem"
      sha256 "5ef4c157436096e6dac49f8b1edc0eb6c8f3b55fc8ffed5d1949a5ca9f04ca9d"
    end

    resource "necromancer" do
      url "https://rubygems.org/gems/necromancer-0.4.0.gem"
      sha256 "7fab7bc465a634365d354341a0f7a57a6928b7b06777442c3b377fb36783366d"
    end

    resource "opto" do
      url "https://rubygems.org/gems/opto-1.8.7.gem"
      sha256 "1e4c231992665fc8fef26f76c8b0d0a7b5e885c5883ba9d8244c6aa153809c7b"
    end

    resource "pastel" do
      url "https://rubygems.org/gems/pastel-0.7.2.gem"
      sha256 "e1d21dd8fb965e5052d1b16164a777fc450c6e187bf199f833a9de3f5303c3f9"
    end

    resource "public_suffix" do
      url "https://rubygems.org/gems/public_suffix-3.0.1.gem"
      sha256 "67182699cb644e66b4c68d30b5f1dd42e3dfe6c0aa0d8fd36a1e71c97c6a7f57"
    end

    resource "rake" do
      url "https://rubygems.org/gems/rake-10.5.0.gem"
      sha256 "2b55a1ad44b5c945719d8a97c302a316af770b835187d12143e83069df5a8a49"
    end

    resource "retriable" do
      url "https://rubygems.org/gems/retriable-2.1.0.gem"
      sha256 "c1e309cd29ca451e9e8aea7685368db0da490d519ced16f79867fae12b9e4384"
    end

    resource "ruby_dig" do
      url "https://rubygems.org/gems/ruby_dig-0.0.2.gem"
      sha256 "e95668c4140f17b9ee0742caaa77e8044bc9f2d990441e846afd57dd8aab97e1"
    end

    resource "semantic" do
      url "https://rubygems.org/gems/semantic-1.6.0.gem"
      sha256 "6ad9e301a564537f18ed01d0d346ab8ef54a908c0f7176937be940c34982804a"
    end

    resource "timers" do
      url "https://rubygems.org/gems/timers-4.1.2.gem"
      sha256 "a7a7148409d5d6a7c04624277f4cc99f7748b40be394afcc4187ada73c2a5d71"
    end

    resource "tty-color" do
      url "https://rubygems.org/gems/tty-color-0.4.2.gem"
      sha256 "2aa4da523710daf3e953f6c58145f5c9338feca76b0d2adfe25a4259cbc4b2c4"
    end

    resource "tty-cursor" do
      url "https://rubygems.org/gems/tty-cursor-0.5.0.gem"
      sha256 "bffb2e54bec3bbb22e4a845ebc0ca8f6afbbc1ce506d2e316955cdb8387eaf76"
    end

    resource "tty-prompt" do
      url "https://rubygems.org/gems/tty-prompt-0.13.1.gem"
      sha256 "fae0612a140f3d6300ebbcbd445582c621755d4673c0029553e7f9a465bbae81"
    end

    resource "tty-screen" do
      url "https://rubygems.org/gems/tty-screen-0.6.3.gem"
      sha256 "9bd1687dfdd8be829ce15b08032588078165746366c0778cbd05020f3e9f0215"
    end

    resource "tty-table" do
      url "https://rubygems.org/gems/tty-table-0.9.0.gem"
      sha256 "03fd0edaf04395d124a58ae0c876a1a2d3ce1aec53e0763a581695cbde5477ee"
    end

    resource "unicode-display_width" do
      url "https://rubygems.org/gems/unicode-display_width-1.1.3.gem"
      sha256 "1d6247805b2431fd3d27614f6e0c38665b068bfc3a58cf89f08b7f107daf48e4"
    end

    resource "unicode_utils" do
      url "https://rubygems.org/gems/unicode_utils-1.4.0.gem"
      sha256 "b922d0cf2313b6b7136ada6645ce7154ffc86418ca07d53b058efe9eb72f2a40"
    end

    resource "verse" do
      url "https://rubygems.org/gems/verse-0.5.0.gem"
      sha256 "4c8af6322b91e115a772af1acdf99952e391ad14890577674e11e52d474af2e0"
    end

    resource "websocket-driver" do
      url "https://rubygems.org/gems/websocket-driver-0.6.5.gem"
      sha256 "b4a4e0c75eae9e85ceb248d4dc13519da581452767dcd5126c1452ea052183a4"
    end

    resource "websocket-extensions" do
      url "https://rubygems.org/gems/websocket-extensions-0.1.3.gem"
      sha256 "e0886634e49a5d0a790b43d49286af0f47b86636257843cb539e8ce64e6e9a0c"
    end

    resource "wisper" do
      url "https://rubygems.org/gems/wisper-2.0.0.gem"
      sha256 "6d8623c76943612e8db81862af7eb20f5a8ad631fe1857d9f7ced97e87e5222b"
    end
  end

  bottle do
    cellar :any
    sha256 "a2aa389c7b1615d7c3cbeab2aceb7420c4117084c9cabab4f619ffbf7e926376" => :high_sierra
    sha256 "9e618bf792135d62d21894eb781cf506545fc57f5ba9a863d60af67f91b84140" => :sierra
    sha256 "5ab1353f88480f709dc936d5123168aa6a5b8ff09073ff9a036727d062f41f6c" => :el_capitan
  end

  depends_on :ruby => "2.1"

  def install
    ENV["GEM_HOME"] = libexec

    cd "cli" do
      system "gem", "build", "--norc", "kontena-cli.gemspec"

      if build.head?
        system "gem", "install", Dir["kontena-cli-*.gem"].first,
               "--no-document", "--norc", "--install-dir", libexec
      else
        resources.each do |r|
          r.verify_download_integrity(r.fetch)
          system "gem", "install", r.cached_download, "--ignore-dependencies",
                 "--no-document", "--norc", "--install-dir", libexec
        end

        system "gem", "install", "--ignore-dependencies", "--norc",
               "--no-document", "kontena-cli-#{version}.gem"
      end
    end

    bin.env_script_all_files(libexec/"bin", :GEM_HOME => ENV["GEM_HOME"])

    env = { :GEM_PATH => libexec, :KONTENA_EXTRA_BUILDTAGS => "homebrew" }

    if build.head?
      commit = Utils.popen_read("git", "rev-parse", "--short", "HEAD").chomp
      env[:KONTENA_EXTRA_BUILDTAGS].concat ",head-#{commit}"
    end

    (bin/"kontena").write_env_script(libexec/"bin/kontena", env)

    bash_completion.install "cli/lib/kontena/scripts/kontena.bash" => "kontena"
    zsh_completion.install "cli/lib/kontena/scripts/kontena.zsh" => "_kontena"
  end

  test do
    assert_match "+homebrew", shell_output("#{bin}/kontena --version")
    assert_match "login", shell_output("#{bin}/kontena complete kontena master")
    output = shell_output("#{bin}/kontena plugin search digitalocean")
    assert_match "Kontena DigitalOcean plugin", output
    output = shell_output("#{bin}/kontena stack reg show kontena/hello-world")
    assert_match "description: Sample stack to test Kontena", output
    assert_match "NAME", shell_output("#{bin}/kontena master list")
  end
end
