class Krane < Formula
  desc "Kubernetes deploy tool with rollout verification"
  homepage "https://github.com/Shopify/krane"
  url "https://rubygems.org/downloads/krane-3.9.0.gem"
  sha256 "f7d2e2e8b39da3311194efe7c5285cc9ff9caa57dc8de8b640aa729daaa4819e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "881a059dd30331ba9a9e17bfa51906ad228ac2adf9881ab4d4cf9d06ce1d14bd"
    sha256 cellar: :any,                 arm64_sequoia: "3d9fa3cc1a63d7d191e1a0dfe3fd87da728fedd057d70ad712b676df86d21457"
    sha256 cellar: :any,                 arm64_sonoma:  "1775c1f38a52ca595446ac343993a8f4beaee320f9469dfe6f3177df00e4d6b4"
    sha256 cellar: :any,                 sonoma:        "0af000dce011204dc420d6a28d8d64fd39370f714a03efe7d258b98897bb8a8d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c6129d4397b21098219b707ea6dd0208380500a641515e39eeacfbaaa0cbeb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b25328ec83904ca0014b94b67742d1f5293d106ab8b9341989c78fd0f5a6b74"
  end

  depends_on "kubernetes-cli"
  depends_on "ruby"

  uses_from_macos "libffi"

  resource "activesupport" do
    url "https://rubygems.org/downloads/activesupport-8.0.2.1.gem"
    sha256 "0405a76fd1ca989975d9ae00d46a4d3979bdf3817482d846b63affa84bd561c6"
  end

  resource "addressable" do
    url "https://rubygems.org/downloads/addressable-2.8.7.gem"
    sha256 "462986537cf3735ab5f3c0f557f14155d778f4b43ea4f485a9deb9c8f7c58232"
  end

  resource "base64" do
    url "https://rubygems.org/downloads/base64-0.2.0.gem"
    sha256 "0f25e9b21a02a0cc0cea8ef92b2041035d39350946e8789c562b2d1a3da01507"
  end

  resource "benchmark" do
    url "https://rubygems.org/downloads/benchmark-0.3.0.gem"
    sha256 "4ca7995224b9982efccee9b44a4464a73201c5779d78cb5a4d99ec2f39acf071"
  end

  resource "bigdecimal" do
    url "https://rubygems.org/downloads/bigdecimal-3.1.5.gem"
    sha256 "534faee5ae3b4a0a6369fe56cd944e907bf862a9209544a9e55f550592c22fac"
  end

  resource "colorize" do
    url "https://rubygems.org/downloads/colorize-0.8.1.gem"
    sha256 "0ba0c2a58232f9b706dc30621ea6aa6468eeea120eb6f1ccc400105b90c4798c"
  end

  resource "concurrent-ruby" do
    url "https://rubygems.org/downloads/concurrent-ruby-1.3.5.gem"
    sha256 "813b3e37aca6df2a21a3b9f1d497f8cbab24a2b94cab325bffe65ee0f6cbebc6"
  end

  resource "connection_pool" do
    url "https://rubygems.org/downloads/connection_pool-2.5.4.gem"
    sha256 "e9e1922327416091f3f6542f5f4446c2a20745276b9aa796dd0bb2fd0ea1e70a"
  end

  resource "domain_name" do
    url "https://rubygems.org/downloads/domain_name-0.6.20240107.gem"
    sha256 "5f693b2215708476517479bf2b3802e49068ad82167bcd2286f899536a17d933"
  end

  resource "drb" do
    url "https://rubygems.org/downloads/drb-2.2.0.gem"
    sha256 "e9e4af1cded3306cfe37e064a0086e302d5f40df9cb4d161d059a6bb3a75d40f"
  end

  resource "ejson" do
    url "https://rubygems.org/downloads/ejson-1.5.3.gem"
    sha256 "37f2935c650b846c1860be4b44d74b7983ae315e463aab5a31c9dae86046591d"
  end

  resource "faraday" do
    url "https://rubygems.org/downloads/faraday-2.13.4.gem"
    sha256 "c719ff52cfd0dbaeca79dd83ed3aeea3f621032abf8bc959d1c05666157cac26"
  end

  resource "faraday-net_http" do
    url "https://rubygems.org/downloads/faraday-net_http-3.4.1.gem"
    sha256 "095757fae7872b94eac839c08a1a4b8d84fd91d6886cfbe75caa2143de64ab3b"
  end

  resource "ffi" do
    url "https://rubygems.org/downloads/ffi-1.17.2.gem"
    sha256 "297235842e5947cc3036ebe64077584bff583cd7a4e94e9a02fdec399ef46da6"
  end

  resource "ffi-compiler" do
    url "https://rubygems.org/downloads/ffi-compiler-1.3.2.gem"
    sha256 "a94f3d81d12caf5c5d4ecf13980a70d0aeaa72268f3b9cc13358bcc6509184a0"
  end

  resource "googleauth" do
    url "https://rubygems.org/downloads/googleauth-1.15.0.gem"
    sha256 "122ae61813805a1cfdf225638f33d354ca6078be17e9712669667226a7243bcf"
  end

  resource "google-cloud-env" do
    url "https://rubygems.org/downloads/google-cloud-env-2.3.1.gem"
    sha256 "0faac01eb27be78c2591d64433663b1a114f8f7af55a4f819755426cac9178e7"
  end

  resource "google-logging-utils" do
    url "https://rubygems.org/downloads/google-logging-utils-0.2.0.gem"
    sha256 "675462b4ea5affa825a3442694ca2d75d0069455a1d0956127207498fca3df7b"
  end

  resource "http" do
    url "https://rubygems.org/downloads/http-5.3.1.gem"
    sha256 "c50802d8e9be3926cb84ac3b36d1a31fbbac383bc4cbecdce9053cb604231d7d"
  end

  resource "http-accept" do
    url "https://rubygems.org/downloads/http-accept-1.7.0.gem"
    sha256 "c626860682bfbb3b46462f8c39cd470fd7b0584f61b3cc9df5b2e9eb9972a126"
  end

  resource "http-cookie" do
    url "https://rubygems.org/downloads/http-cookie-1.0.8.gem"
    sha256 "b14fe0445cf24bf9ae098633e9b8d42e4c07c3c1f700672b09fbfe32ffd41aa6"
  end

  resource "http-form_data" do
    url "https://rubygems.org/downloads/http-form_data-2.3.0.gem"
    sha256 "cc4eeb1361d9876821e31d7b1cf0b68f1cf874b201d27903480479d86448a5f3"
  end

  resource "i18n" do
    url "https://rubygems.org/downloads/i18n-1.14.7.gem"
    sha256 "ceba573f8138ff2c0915427f1fc5bdf4aa3ab8ae88c8ce255eb3ecf0a11a5d0f"
  end

  resource "json" do
    url "https://rubygems.org/downloads/json-2.7.2.gem"
    sha256 "1898b5cbc81cd36c0fd4d0b7ad2682c39fb07c5ff682fc6265f678f550d4982c"
  end

  resource "jsonpath" do
    url "https://rubygems.org/downloads/jsonpath-1.1.5.gem"
    sha256 "29f70467193a2dc93ab864ec3d3326d54267961acc623f487340eb9c34931dbe"
  end

  resource "jwt" do
    url "https://rubygems.org/downloads/jwt-3.1.2.gem"
    sha256 "af6991f19a6bb4060d618d9add7a66f0eeb005ac0bc017cd01f63b42e122d535"
  end

  resource "kubeclient" do
    url "https://rubygems.org/downloads/kubeclient-4.12.0.gem"
    sha256 "8610b90f8c767303a633b0aafa53d9f61af03f5d9fca96fc0f21380843c309bd"
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

  resource "logger" do
    url "https://rubygems.org/downloads/logger-1.7.0.gem"
    sha256 "196edec7cc44b66cfb40f9755ce11b392f21f7967696af15d274dde7edff0203"
  end

  resource "mime-types" do
    url "https://rubygems.org/downloads/mime-types-3.7.0.gem"
    sha256 "dcebf61c246f08e15a4de34e386ebe8233791e868564a470c3fe77c00eed5e56"
  end

  resource "mime-types-data" do
    url "https://rubygems.org/downloads/mime-types-data-3.2025.0902.gem"
    sha256 "5d8397fb76c075b483bed1d5ec64426d80aa6cd2133f3c0dc1dbb93aa85b1e1a"
  end

  resource "minitest" do
    url "https://rubygems.org/downloads/minitest-5.20.0.gem"
    sha256 "a3faf26a757ced073aaae0bd10481340f53e221a4f50d8a6033591555374752e"
  end

  resource "multi_json" do
    url "https://rubygems.org/downloads/multi_json-1.17.0.gem"
    sha256 "76581f6c96aebf2e85f8a8b9854829e0988f335e8671cd1a56a1036eb75e4a1b"
  end

  resource "net-http" do
    url "https://rubygems.org/downloads/net-http-0.6.0.gem"
    sha256 "9621b20c137898af9d890556848c93603716cab516dc2c89b01a38b894e259fb"
  end

  resource "netrc" do
    url "https://rubygems.org/downloads/netrc-0.11.0.gem"
    sha256 "de1ce33da8c99ab1d97871726cba75151113f117146becbe45aa85cb3dabee3f"
  end

  resource "os" do
    url "https://rubygems.org/downloads/os-1.1.4.gem"
    sha256 "57816d6a334e7bd6aed048f4b0308226c5fb027433b67d90a9ab435f35108d3f"
  end

  resource "ostruct" do
    url "https://rubygems.org/downloads/ostruct-0.6.0.gem"
    sha256 "3b1736c99f4d985de36bde1155be5e22aaf6e564b30ff9bd481e2ef7c2d9ba85"
  end

  resource "public_suffix" do
    url "https://rubygems.org/downloads/public_suffix-6.0.2.gem"
    sha256 "bfa7cd5108066f8c9602e0d6d4114999a5df5839a63149d3e8b0f9c1d3558394"
  end

  resource "rake" do
    url "https://rubygems.org/downloads/rake-13.1.0.gem"
    sha256 "be6a3e1aa7f66e6c65fa57555234eb75ce4cf4ada077658449207205474199c6"
  end

  resource "recursive-open-struct" do
    url "https://rubygems.org/downloads/recursive-open-struct-1.3.1.gem"
    sha256 "141b4a9c8817bb30f4275c5adb1b5bebaba41bf9b7dd6d6a75ad394390ad8720"
  end

  resource "rest-client" do
    url "https://rubygems.org/downloads/rest-client-2.1.0.gem"
    sha256 "35a6400bdb14fae28596618e312776c158f7ebbb0ccad752ff4fa142bf2747e3"
  end

  resource "ruby2_keywords" do
    url "https://rubygems.org/downloads/ruby2_keywords-0.0.5.gem"
    sha256 "ffd13740c573b7301cf7a2e61fc857b2a8e3d3aff32545d6f8300d8bae10e3ef"
  end

  resource "securerandom" do
    url "https://rubygems.org/downloads/securerandom-0.3.1.gem"
    sha256 "98f0450c0ea46d2f9a4b6db4f391dbd83dc08049592eada155739f40e0341bde"
  end

  resource "signet" do
    url "https://rubygems.org/downloads/signet-0.21.0.gem"
    sha256 "d617e9fbf24928280d39dcfefba9a0372d1c38187ffffd0a9283957a10a8cd5b"
  end

  resource "statsd-instrument" do
    url "https://rubygems.org/downloads/statsd-instrument-3.8.0.gem"
    sha256 "122e294845d9a05a74fa53a859010424b455b44f1605abac3108fbbabb2aa7cd"
  end

  resource "thor" do
    url "https://rubygems.org/downloads/thor-1.4.0.gem"
    sha256 "8763e822ccb0f1d7bee88cde131b19a65606657b847cc7b7b4b82e772bcd8a3d"
  end

  resource "tzinfo" do
    url "https://rubygems.org/downloads/tzinfo-2.0.6.gem"
    sha256 "8daf828cc77bcf7d63b0e3bdb6caa47e2272dcfaf4fbfe46f8c3a9df087a829b"
  end

  resource "uri" do
    url "https://rubygems.org/downloads/uri-0.13.2.gem"
    sha256 "a557196e652011bcff0b36d29f9e427fefcf60cc35c0ab8cce08768a6287e457"
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
