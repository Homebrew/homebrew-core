class Blint < Formula
  include Language::Python::Virtualenv

  desc "Security linter and SBOM generator for binaries"
  homepage "https://github.com/owasp-dep-scan/blint"
  url "https://files.pythonhosted.org/packages/1e/dd/725045c70ee77dfff3952bce3dedbb960bd80e059d81c232a795b725189c/blint-4.1.1.tar.gz"
  sha256 "3d8d5648e47d017d52951362bd7efe17a185c61d66e51856f3e58c01121d00b0"
  license "MIT"
  head "https://github.com/owasp-dep-scan/blint.git", branch: "main"

  bottle do
    manifest_sha256 "3f59196b3b5331d5dabbfeb880db7593adb73986b4cfb1c434e05766da70f5bb"
    sha256 cellar: :any, arm64_golden_gate: "8d99b7dc2c917bed814d2a7fc9cd124d8a710cc0c6cdda6e193c4a6ec678e77e"
    sha256 cellar: :any, arm64_tahoe:       "424f2684788b618efb34d8934925017b61e2d786ac6eb7843809fbd3dc8ec68b"
    sha256 cellar: :any, arm64_sequoia:     "29ac924eac21e11875f09083761a5b09c0f61c06538d2da25bcffdd9e403f115"
    sha256 cellar: :any, arm64_linux:       "4764cc69280bb805eef2f9cfa441a6441f019538f6e694e138d62e7282208c2d"
    sha256 cellar: :any, x86_64_linux:      "39aaac9a96660fc30b6fc31766c83bd31a24d758dc30d3fc96a0fbaf0945e102"
  end

  depends_on "cmake" => :build # for lief
  depends_on "ninja" => :build # for lief
  depends_on "rust" => :build
  depends_on "tl-expected" => :build # for lief
  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "lief"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.15"
  depends_on "rpds-py" => :no_linkage
  depends_on "sqlite" # APSW needs a newer version of SQLite than what macOS ships with

  pypi_packages exclude_packages: %w[certifi pydantic rpds-py]

  resource "apkinspector" do
    url "https://files.pythonhosted.org/packages/d4/8d/dd382dd4fd58799634d66d8f6eafe2c951a35971aacad6f6f3df6f111383/apkinspector-1.3.7.tar.gz"
    sha256 "ea5a62f9c6a3127a6191901fa0cc32e23b05caf2034d7062193bd4c0539c7888"
  end

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "apsw" do
    url "https://files.pythonhosted.org/packages/84/75/be84a7237ea1af8374c67ff7468053bff538e1591526805c6574b2efef4d/apsw-3.54.1.0.tar.gz"
    sha256 "d9fd64ed76dc0f3d2265d4aeedb74d678c2ac7dffbd4e8ba05bf9a87aa7c34d3"
  end

  resource "ar" do
    url "https://files.pythonhosted.org/packages/2b/0f/13f26fda15101f3415fab75456f5abc967a8c848287cf0b3dabc4b64d65a/ar-1.0.1.tar.gz"
    sha256 "8fc8e64ac2fd157b9f285b1c981083f2e906258322ff5e4413c0096f67fc2003"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/c2/c3/cae6d3bdefd96a941ffc247c714ac4babc488a69012e11c058f6c17c6c47/charset_normalizer-3.5.3.tar.gz"
    sha256 "a250888753faa289e2997962fbb17c4960cbdb58575533ca6fceee68c224bdff"
  end

  resource "custom-json-diff" do
    url "https://files.pythonhosted.org/packages/b6/f9/670514efaceb028f739106231acfae1813638387742e130cd5561949c10e/custom_json_diff-2.1.6.tar.gz"
    sha256 "26d62a7f2fc61327c3bcda00b65d820f503682f242afcb1d2305186f8745e10e"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/76/49/900383b471c645a3c397f47b3211d1fcecb3a540c98f683494cdf86b33de/dnspython-2.9.2.tar.gz"
    sha256 "8d4d39a513e649d634004ce4d39ade2352efcea472a0247535a5c2d18a9d7ba9"
  end

  resource "email-validator" do
    url "https://files.pythonhosted.org/packages/c0/4d/f5e9d9de19f4b8f9e33d802fe3efb0ef96e88d4d6d45d604f335bef2f1ef/email_validator-2.4.0.tar.gz"
    sha256 "be487bc50bc3bd832a98515a55a15649d9bec06d954fa178663190714b6c4ee1"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "json-flatten" do
    url "https://files.pythonhosted.org/packages/a1/06/e6a7046e71488a899a990206dc2426e8b9192ab7a341bb95a75ac1c88922/json_flatten-0.3.1.tar.gz"
    sha256 "70e813acf431b1ab7e9eb7b98f5733d307d6b9d27b553a344904b9c8eafdad3a"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/b3/fc/e067678238fa451312d4c62bf6e6cf5ec56375422aee02f9cb5f909b3047/jsonschema-4.26.0.tar.gz"
    sha256 "0c26707e2efad8aa1bfc5b7ce170f3fccc2e4918ff85989ba9ffa9facb2be326"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/19/74/a633ee74eb36c44aa6d1095e7cc5569bebf04342ee146178e2d36600708b/jsonschema_specifications-2025.9.1.tar.gz"
    sha256 "b540987f239e745613c7a9176f3edb72b832a4ac465cf02712288397832b5e8d"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/16/fc/cee2c45553c9a9bf77d8b0c391560c556d7ed756b1f0bb35eb5d48db09ea/markdown_it_py-4.3.0.tar.gz"
    sha256 "91a58fa5b72c71a40cf7177250fd767480d7a2bb3ac426ccfb76fb90305fdaaa"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/38/9b/e422a865e1d5d57d0e509b4e0bf1c1a70a7f6382c29a5aa428df994c8bc8/markupsafe-3.0.4.tar.gz"
    sha256 "2e9ad7dd851bf45fab9f75cbff4cb493fee9979e8d8c7c9c3ee119022518edd6"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "multi-demangle" do
    url "https://files.pythonhosted.org/packages/c6/7b/56d77b4171d89276ad93a3ab11fbb2a44d85b0904c0467841cb9d41c5997/multi_demangle-2.1.1.tar.gz"
    sha256 "e453c1c1286935e0653ffc570a327dc9b2509bba5c29170660d63a1640537366"
  end

  resource "oras" do
    url "https://files.pythonhosted.org/packages/c0/92/45719088d695714259d768a286639b3563e931db8e46e3820427ca6040e8/oras-0.2.44.tar.gz"
    sha256 "4bc8ebf56f324f5ca8e2278e4ceaa906ffb5e5030d198b80c073e8338e54acf5"
  end

  resource "orjson" do
    url "https://files.pythonhosted.org/packages/f2/72/380b97dc45bd162d23afe5194721ef678d9eac7cfaa549fe2873f7f0a518/orjson-3.13.0.tar.gz"
    sha256 "d1de5eb04485110c5da4c657e49168995d55e076b1ce60f1a042e254f4186c4f"
  end

  resource "packageurl-python" do
    url "https://files.pythonhosted.org/packages/f5/d6/3b5a4e3cfaef7a53869a26ceb034d1ff5e5c27c814ce77260a96d50ab7bb/packageurl_python-0.17.6.tar.gz"
    sha256 "1252ce3a102372ca6f86eb968e16f9014c4ba511c5c37d95a7f023e2ca6e5c25"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/76/b8/c0b780928e2fb1c87e9e375818c6f121da2398b071012d1747be300b83f4/pyyaml-6.0.4.tar.gz"
    sha256 "e24bf71af8a432d7808fabff134d38dfe16d3cbb41f2873bb4b1e42422de0a1a"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/22/f5/df4e9027acead3ecc63e50fe1e36aca1523e1719559c499951bb4b53188f/referencing-0.37.0.tar.gz"
    sha256 "44aefc3142c5b842538163acb373e24cce6632bd54bdb01b21ad5863489f50d8"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "semver" do
    url "https://files.pythonhosted.org/packages/ec/a0/3d3f51a1304c0e8c93e06a23308f566f2d52d62f92dac903b85ef79dea6f/semver-3.1.2.tar.gz"
    sha256 "bea193552413194252d33ff26ce0962b76669bd1c6fb17e8e203ac37f072feaf"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  resource "wasm-tools" do
    url "https://files.pythonhosted.org/packages/dc/dc/cab147acaa95ce52570eddfb8a3bd5d2cbe984ef16ef75f33dfd4679e5f2/wasm_tools-2.2.0.tar.gz"
    sha256 "2453fbae76a802b4b7198991e862cdd5b87d34dc565d7e84b84bf4a143a513d3"
  end

  # Python bindings for the `lief` formula, so keep both at the same version
  # The PyPI sdist has no sources to build from
  resource "lief" do
    url "https://github.com/lief-project/LIEF/archive/refs/tags/1.0.0.tar.gz"
    sha256 "2cf412695ff739d82e129db441e5c2025f3bb4873a3d3a1d3dd4cf300b682abd"

    livecheck do
      url :url
    end
  end

  resource "homebrew-test-library", :test do
    url "https://raw.githubusercontent.com/owasp-dep-scan/blint/fc39d1202f550d701a9f6564230488aa96e8cc26/tests/data/android/liba5_static_arm64-v8a_stripped.so"
    sha256 "fd8fd1b3e5b31ffbb583b952aa7864a87fdeb969b97bccf6fbf9b74ceb836a0b"

    livecheck do
      skip "Test resource"
    end
  end

  deny_network_access! :test

  def install
    venv = virtualenv_install_with_resources without: %w[apsw lief]

    resource("apsw").stage do
      # Use the brewed SQLite library instead of downloading and building one
      rm "setup.apsw"
      venv.pip_install Pathname.pwd
    end

    # Build only the Python bindings, linking the brewed LIEF library
    # https://lief.re/doc/latest/compilation.html#python-bindings
    resource("lief").stage do
      inreplace "api/python/config-default.toml", "[lief.build]\n", <<~TOML
        [lief.build]
        lief-install-dir = "#{formula_opt_prefix("lief")}"
        extra-cmake-opt = ["-DLIEF_PY_LIEF_EXT_SHARED=ON"]
      TOML
      # LIEF's CMake package only finds its dependencies for the static library,
      # but the shared one also links `tl::expected`
      inreplace "CMakeLists.txt", "find_package(LIEF REQUIRED)\n", <<~CMAKE
        find_package(tl-expected REQUIRED)
        find_package(LIEF REQUIRED)
      CMAKE
      venv.pip_install Pathname.pwd/"api/python"
    end
  end

  test do
    resource("homebrew-test-library").stage testpath
    library = "liba5_static_arm64-v8a_stripped.so"

    system bin/"blint", "-i", library, "-o", "reports"
    findings = JSON.parse((testpath/"reports/findings.json").read)["findings"]
    assert_includes findings.map { |finding| finding["id"] }, "CHECK_CANARY"

    system bin/"blint", "sbom", "-i", library, "-o", "bom.json"
    components = JSON.parse((testpath/"bom.json").read)["components"]
    assert_includes components.map { |component| component["name"] }, "libc.so"
  end
end
