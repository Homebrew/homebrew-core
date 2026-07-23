class Krane < Formula
  desc "Kubernetes deploy tool with rollout verification"
  homepage "https://github.com/Shopify/krane"
  url "https://rubygems.org/downloads/krane-3.9.1.gem"
  sha256 "eda88d26175aaf257df71b55b5df9d4868710a28df2b595bebadc1192a65bb8d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c6f7ce0880691e99783350621b81f818c2ab45895deda32fb071b718f7ae9c3c"
    sha256 cellar: :any,                 arm64_sequoia: "d7654441d438414758693a1ea71be2f1158b81363cc392de3854566c9805d1a6"
    sha256 cellar: :any,                 arm64_sonoma:  "6201a5021aaf84c0783e76164be2007faa3194d8277e607296c82c35a180c510"
    sha256 cellar: :any,                 sonoma:        "fcee877569b1606da620e2e189084e1aa1d902f56ca0b453d6838e2f625dd643"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08545226cfed372f535b9aa70549de7ab57782bbc5793082005f357a04f5d768"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56898f13d9e4ece67e8720802746036fab763dad1a8bf90de3cd59e0c905d0d6"
  end

  depends_on "kubernetes-cli"
  depends_on "ruby"

  uses_from_macos "libffi"

  # List with `gem install --explain krane -v #{version}`
  # https://rubygems.org/gems/krane/versions/#{version}/dependencies

  resource "thor" do
    url "https://rubygems.org/downloads/thor-1.5.0.gem"
    sha256 "e3a9e55fe857e44859ce104a84675ab6e8cd59c650a49106a05f55f136425e73"
  end

  resource "statsd-instrument" do
    url "https://rubygems.org/downloads/statsd-instrument-3.8.0.gem"
    sha256 "122e294845d9a05a74fa53a859010424b455b44f1605abac3108fbbabb2aa7cd"
  end

  resource "multi_json" do
    url "https://rubygems.org/downloads/multi_json-1.19.1.gem"
    sha256 "7aefeff8f2c854bf739931a238e4aea64592845e0c0395c8a7d2eea7fdd631b7"
  end

  resource "netrc" do
    url "https://rubygems.org/downloads/netrc-0.11.0.gem"
    sha256 "de1ce33da8c99ab1d97871726cba75151113f117146becbe45aa85cb3dabee3f"
  end

  resource "mime-types-data" do
    url "https://rubygems.org/downloads/mime-types-data-3.2025.0924.gem"
    sha256 "f276bca15e59f35767cbcf2bc10e023e9200b30bd6a572c1daf7f4cc24994728"
  end

  resource "logger" do
    url "https://rubygems.org/downloads/logger-1.7.0.gem"
    sha256 "196edec7cc44b66cfb40f9755ce11b392f21f7967696af15d274dde7edff0203"
  end

  resource "mime-types" do
    url "https://rubygems.org/downloads/mime-types-3.7.0.gem"
    sha256 "dcebf61c246f08e15a4de34e386ebe8233791e868564a470c3fe77c00eed5e56"
  end

  resource "domain_name" do
    url "https://rubygems.org/downloads/domain_name-0.6.20240107.gem"
    sha256 "5f693b2215708476517479bf2b3802e49068ad82167bcd2286f899536a17d933"
  end

  resource "http-cookie" do
    url "https://rubygems.org/downloads/http-cookie-1.1.0.gem"
    sha256 "38a5e60d1527eebc396831b8c4b9455440509881219273a6c99943d29eadbb19"
  end

  resource "http-accept" do
    url "https://rubygems.org/downloads/http-accept-1.7.0.gem"
    sha256 "c626860682bfbb3b46462f8c39cd470fd7b0584f61b3cc9df5b2e9eb9972a126"
  end

  resource "rest-client" do
    url "https://rubygems.org/downloads/rest-client-2.1.0.gem"
    sha256 "35a6400bdb14fae28596618e312776c158f7ebbb0ccad752ff4fa142bf2747e3"
  end

  resource "ostruct" do
    url "https://rubygems.org/downloads/ostruct-0.6.3.gem"
    sha256 "95a2ed4a4bd1d190784e666b47b2d3f078e4a9efda2fccf18f84ddc6538ed912"
  end

  resource "recursive-open-struct" do
    url "https://rubygems.org/downloads/recursive-open-struct-1.3.1.gem"
    sha256 "141b4a9c8817bb30f4275c5adb1b5bebaba41bf9b7dd6d6a75ad394390ad8720"
  end

  resource "jsonpath" do
    url "https://rubygems.org/downloads/jsonpath-1.1.5.gem"
    sha256 "29f70467193a2dc93ab864ec3d3326d54267961acc623f487340eb9c34931dbe"
  end

  resource "rake" do
    url "https://rubygems.org/downloads/rake-13.3.1.gem"
    sha256 "8c9e89d09f66a26a01264e7e3480ec0607f0c497a861ef16063604b1b08eb19c"
  end

  resource "ffi" do
    url "https://rubygems.org/downloads/ffi-1.17.3.gem"
    sha256 "0e9f39f7bb3934f77ad6feab49662be77e87eedcdeb2a3f5c0234c2938563d4c"
  end

  resource "ffi-compiler" do
    url "https://rubygems.org/downloads/ffi-compiler-1.3.2.gem"
    sha256 "a94f3d81d12caf5c5d4ecf13980a70d0aeaa72268f3b9cc13358bcc6509184a0"
  end

  # TODO: Uploaded gem has aarch64-darwin prebuilt binaries. To make sure these
  # are correctly rebuilt from source, we temporarily use the GitHub tarball
  # which corresponds to 0.5.1. Check on new release if gem can be restored.
  resource "llhttp-ffi" do
    # url "https://rubygems.org/downloads/llhttp-ffi-0.5.1.gem"
    url "https://github.com/bryanp/llhttp/archive/refs/tags/2025-03-11.tar.gz"
    version "0.5.1"
    sha256 "ac334092160db470655dfbab6c9462a4a7ce189f75afe36fe3884cbc42c5550c"
  end

  resource "http-form_data" do
    url "https://rubygems.org/downloads/http-form_data-2.3.0.gem"
    sha256 "cc4eeb1361d9876821e31d7b1cf0b68f1cf874b201d27903480479d86448a5f3"
  end

  resource "public_suffix" do
    url "https://rubygems.org/downloads/public_suffix-7.0.2.gem"
    sha256 "9114090c8e4e7135c1fd0e7acfea33afaab38101884320c65aaa0ffb8e26a857"
  end

  resource "addressable" do
    url "https://rubygems.org/downloads/addressable-2.8.8.gem"
    sha256 "7c13b8f9536cf6364c03b9d417c19986019e28f7c00ac8132da4eb0fe393b057"
  end

  resource "http" do
    url "https://rubygems.org/downloads/http-5.3.1.gem"
    sha256 "c50802d8e9be3926cb84ac3b36d1a31fbbac383bc4cbecdce9053cb604231d7d"
  end

  resource "kubeclient" do
    url "https://rubygems.org/downloads/kubeclient-4.13.0.gem"
    sha256 "51f666b14461e1933328670c5b21114d52518b420562728792e1579a9dde0693"
  end

  resource "base64" do
    url "https://rubygems.org/downloads/base64-0.3.0.gem"
    sha256 "27337aeabad6ffae05c265c450490628ef3ebd4b67be58257393227588f5a97b"
  end

  resource "jwt" do
    url "https://rubygems.org/downloads/jwt-3.1.2.gem"
    sha256 "af6991f19a6bb4060d618d9add7a66f0eeb005ac0bc017cd01f63b42e122d535"
  end

  resource "json" do
    url "https://rubygems.org/downloads/json-2.18.0.gem"
    sha256 "b10506aee4183f5cf49e0efc48073d7b75843ce3782c68dbeb763351c08fd505"
  end

  resource "uri" do
    url "https://rubygems.org/downloads/uri-1.1.1.gem"
    sha256 "379fa58d27ffb1387eaada68c749d1426738bd0f654d812fcc07e7568f5c57c6"
  end

  resource "net-http" do
    url "https://rubygems.org/downloads/net-http-0.9.1.gem"
    sha256 "25ba0b67c63e89df626ed8fac771d0ad24ad151a858af2cc8e6a716ca4336996"
  end

  resource "faraday-net_http" do
    url "https://rubygems.org/downloads/faraday-net_http-3.4.2.gem"
    sha256 "f147758260d3526939bf57ecf911682f94926a3666502e24c69992765875906c"
  end

  resource "faraday" do
    url "https://rubygems.org/downloads/faraday-2.14.0.gem"
    sha256 "8699cfe5d97e55268f2596f9a9d5a43736808a943714e3d9a53e6110593941cd"
  end

  resource "signet" do
    url "https://rubygems.org/downloads/signet-0.21.0.gem"
    sha256 "d617e9fbf24928280d39dcfefba9a0372d1c38187ffffd0a9283957a10a8cd5b"
  end

  resource "os" do
    url "https://rubygems.org/downloads/os-1.1.4.gem"
    sha256 "57816d6a334e7bd6aed048f4b0308226c5fb027433b67d90a9ab435f35108d3f"
  end

  resource "google-logging-utils" do
    url "https://rubygems.org/downloads/google-logging-utils-0.2.0.gem"
    sha256 "675462b4ea5affa825a3442694ca2d75d0069455a1d0956127207498fca3df7b"
  end

  resource "google-cloud-env" do
    url "https://rubygems.org/downloads/google-cloud-env-2.3.1.gem"
    sha256 "0faac01eb27be78c2591d64433663b1a114f8f7af55a4f819755426cac9178e7"
  end

  resource "googleauth" do
    url "https://rubygems.org/downloads/googleauth-1.16.0.gem"
    sha256 "1e7b5c2ee7edc6a0f5a4a4312c579b3822dc0be2679d6d09ca19d8c7ca5bd5f1"
  end

  resource "ejson" do
    url "https://rubygems.org/downloads/ejson-1.5.3.gem"
    sha256 "37f2935c650b846c1860be4b44d74b7983ae315e463aab5a31c9dae86046591d"
  end

  resource "concurrent-ruby" do
    url "https://rubygems.org/downloads/concurrent-ruby-1.3.6.gem"
    sha256 "6b56837e1e7e5292f9864f34b69c5a2cbc75c0cf5338f1ce9903d10fa762d5ab"
  end

  resource "colorize" do
    url "https://rubygems.org/downloads/colorize-0.8.1.gem"
    sha256 "0ba0c2a58232f9b706dc30621ea6aa6468eeea120eb6f1ccc400105b90c4798c"
  end

  resource "tzinfo" do
    url "https://rubygems.org/downloads/tzinfo-2.0.6.gem"
    sha256 "8daf828cc77bcf7d63b0e3bdb6caa47e2272dcfaf4fbfe46f8c3a9df087a829b"
  end

  resource "securerandom" do
    url "https://rubygems.org/downloads/securerandom-0.4.1.gem"
    sha256 "cc5193d414a4341b6e225f0cb4446aceca8e50d5e1888743fac16987638ea0b1"
  end

  resource "prism" do
    url "https://rubygems.org/downloads/prism-1.7.0.gem"
    sha256 "10062f734bf7985c8424c44fac382ac04a58124ea3d220ec3ba9fe4f2da65103"
  end

  resource "minitest" do
    url "https://rubygems.org/downloads/minitest-6.0.0.gem"
    sha256 "4ca597fc1d735ea18d2b4b98c5fb1d5a6da4a6f35ddf32bd5fa3eded33a453be"
  end

  resource "i18n" do
    url "https://rubygems.org/downloads/i18n-1.14.8.gem"
    sha256 "285778639134865c5e0f6269e0b818256017e8cde89993fdfcbfb64d088824a5"
  end

  resource "drb" do
    url "https://rubygems.org/downloads/drb-2.2.3.gem"
    sha256 "0b00d6fdb50995fe4a45dea13663493c841112e4068656854646f418fda13373"
  end

  resource "connection_pool" do
    url "https://rubygems.org/downloads/connection_pool-3.0.2.gem"
    sha256 "33fff5ba71a12d2aa26cb72b1db8bba2a1a01823559fb01d29eb74c286e62e0a"
  end

  resource "bigdecimal" do
    url "https://rubygems.org/downloads/bigdecimal-4.0.1.gem"
    sha256 "8b07d3d065a9f921c80ceaea7c9d4ae596697295b584c296fe599dd0ad01c4a7"
  end

  resource "activesupport" do
    url "https://rubygems.org/downloads/activesupport-8.1.1.gem"
    sha256 "5e92534e8d0c8b8b5e6b16789c69dbea65c1d7b752269f71a39422e9546cea67"
  end

  def install
    ENV["GEM_HOME"] = libexec

    resources.each do |r|
      next if r.name == "llhttp-ffi"

      r.fetch
      system "gem", "install", r.cached_download,
             "--no-document", "--install-dir", libexec, "--ignore-dependencies"
    end

    resource("llhttp-ffi").stage do |r|
      cd "ffi" do
        system "gem", "build", "llhttp-ffi.gemspec"
        system "gem", "install", "llhttp-ffi-#{r.version}.gem",
               "--no-document", "--install-dir", libexec, "--ignore-dependencies"
      end
    end

    system "gem", "install", cached_download,
      "--no-document", "--install-dir", libexec, "--ignore-dependencies"

    # Remove vendored prebuilt binaries (Homebrew policy: no vendored binaries)
    rm_r(libexec.glob("gems/ejson-*/build"))

    (bin/"krane").write_env_script libexec/"bin/krane", GEM_HOME: ENV["GEM_HOME"]

    # Remove mkmf.log files to avoid shims references
    rm Dir["#{libexec}/extensions/*/*/*/mkmf.log"]
  end

  test do
    # assert the installed krane binary reports the expected version
    assert_match version.to_s, shell_output("#{bin}/krane version 2>/dev/null")

    # provide one ERB template containing two YAML documents
    (testpath/"k8s").mkpath
    (testpath/"k8s/app.yaml.erb").write <<~YML
      apiVersion: v1
      kind: ConfigMap
      metadata:
        name: <%= app_name %>
      data:
        LOG_LEVEL: <%= log_level %>
      ---
      apiVersion: v1
      kind: Pod
      metadata:
        name: <%= app_name %>
      spec:
        containers:
        - name: nginx
          image: nginx:1.14.2
          ports:
          - containerPort: <%= port %>
    YML

    # provide bindings file consumed by the template.
    (testpath/"bindings.yaml").write <<~YML
      app_name: brew
      log_level: info
      port: 80
    YML

    # render and capture output
    out = shell_output(
      "#{bin}/krane render " \
      "-f #{testpath}/k8s/app.yaml.erb " \
      "--bindings='@#{testpath}/bindings.yaml' " \
      "2>/dev/null",
    )

    # krane prefixes output with '---'
    expected = <<~YML
      ---
      apiVersion: v1
      kind: ConfigMap
      metadata:
        name: brew
      data:
        LOG_LEVEL: info
      ---
      apiVersion: v1
      kind: Pod
      metadata:
        name: brew
      spec:
        containers:
        - name: nginx
          image: nginx:1.14.2
          ports:
          - containerPort: 80
    YML

    # assert krane render output
    assert_equal expected, out
  end
end
