class MetaPackageManager < Formula
  include Language::Python::Virtualenv
  include Language::Python::Shebang

  desc "Wrapper around all package managers with a unifying CLI"
  homepage "https://kdeldycke.github.io/meta-package-manager/"
  url "https://files.pythonhosted.org/packages/72/d3/d8cf8f6597ba5e14d5c9c6888bc980426bb3edbbf3b4afab41b8bd988efc/meta_package_manager-6.4.1.tar.gz"
  sha256 "18b78e18ad3676a7769a91ab359574024c9a18946084e33ae370a4e4f4a60fe6"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/kdeldycke/meta-package-manager.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2c218dd54352b2d7039df90dded576165845a94bc81da293267f3e8b19a4d8a7"
    sha256 cellar: :any,                 arm64_sequoia: "123b9e714407c42a02746c1309911ca8d0a91e33ee76786b49dbc766af95902b"
    sha256 cellar: :any,                 arm64_sonoma:  "69259b327a3163c47d8c3d5530d9703c2cd49466e5b6819f4a907c789672aff3"
    sha256 cellar: :any,                 sonoma:        "0e1506d74ec3ebe607d1379a25aae2108f4f7ca13348479248a69ac333a5d02e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03cd664b3cce87831a0a358bb9fde0c6cbce0bd04d2220990400e2dab7252a5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b00e1f685cd1bcd338dbafe2e2f5547db11435a95f2564848105ab205070f739"
  end

  depends_on "rust" => :build

  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.14"
  depends_on "rpds-py" => :no_linkage

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  pypi_packages exclude_packages: ["certifi", "rpds-py"]

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/b9/33/032cdc44182491aa708d06a68b62434140d8c50820a087fac7af37703357/arrow-1.4.0.tar.gz"
    sha256 "ed0cc050e98001b8779e84d461b0098c4ac597e88704a655582b21d116e526d7"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "beartype" do
    url "https://files.pythonhosted.org/packages/c7/94/1009e248bbfbab11397abca7193bea6626806be9a327d399810d523a07cb/beartype-0.22.9.tar.gz"
    sha256 "8f82b54aa723a2848a56008d18875f91c1db02c32ef6a62319a002e3e25a975f"
  end

  resource "boltons" do
    url "https://files.pythonhosted.org/packages/63/54/71a94d8e02da9a865587fb3fff100cb0fc7aa9f4d5ed9ed3a591216ddcc7/boltons-25.0.0.tar.gz"
    sha256 "e110fbdc30b7b9868cb604e3f71d4722dd8f4dcb4a5ddd06028ba8f1ab0b5ace"
  end

  resource "boolean-py" do
    url "https://files.pythonhosted.org/packages/c4/cf/85379f13b76f3a69bca86b60237978af17d6aa0bc5998978c3b8cf05abb2/boolean_py-5.0.tar.gz"
    sha256 "60cbc4bad079753721d32649545505362c754e121570ada4658b852a3a318d95"
  end

  resource "bracex" do
    url "https://files.pythonhosted.org/packages/63/9a/fec38644694abfaaeca2798b58e276a8e61de49e2e37494ace423395febc/bracex-2.6.tar.gz"
    sha256 "98f1347cd77e22ee8d967a30ad4e310b233f7754dbf31ff3fceb76145ba47dc7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e7/a1/67fe25fac3c7642725500a3f6cfe5821ad557c3abb11c9d20d12c7008d3e/charset_normalizer-3.4.7.tar.gz"
    sha256 "ae89db9e5f98a11a4bf50407d4363e7b09b31e55bc117b4f7d80aab97ba009e5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/bb/63/f9e1ea081ce35720d8b92acde70daaedace594dc93b693c869e0d5910718/click-8.3.3.tar.gz"
    sha256 "398329ad4837b2ff7cbe1dd166a4c0f8900c3ca3a218de04466f38f6497f18a2"
  end

  resource "click-extra" do
    url "https://files.pythonhosted.org/packages/98/ee/a2bf0ca48304aff973e3d387364f4b60862be8d16247a6101a148cb9a637/click_extra-7.15.0.tar.gz"
    sha256 "ca56ffd64c3afc5d302c68e894eb955a9457dc5dcb7be9e22d74d2073d1e56ac"
  end

  resource "cloup" do
    url "https://files.pythonhosted.org/packages/f9/64/7f0a66021ff81d51859c66adc13f3c71f0306c2f8dfb9877a0694cbada05/cloup-3.0.9.tar.gz"
    sha256 "519f524d3c64040e49a0866b5fc0bfd6af3eac0d3d6a4b2b50b33ab0247db2d7"
  end

  resource "cyclonedx-python-lib" do
    url "https://files.pythonhosted.org/packages/21/0d/64f02d3fd9c116d6f50a540d04d1e4f2e3c487f5062d2db53733ddb25917/cyclonedx_python_lib-11.7.0.tar.gz"
    sha256 "fb1bc3dedfa31208444dbd743007f478ab6984010a184e5bd466bffd969e936e"
  end

  resource "deepmerge" do
    url "https://files.pythonhosted.org/packages/a8/3a/b0ba594708f1ad0bc735884b3ad854d3ca3bdc1d741e56e40bbda6263499/deepmerge-2.0.tar.gz"
    sha256 "5c3d86081fbebd04dd5de03626a0607b809a98fb6ccba5770b62466fe940ff20"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "extra-platforms" do
    url "https://files.pythonhosted.org/packages/4c/f6/a20c4586c9bd653f596258455652725405f4b734e6270f7fc07a1a498932/extra_platforms-12.0.3.tar.gz"
    sha256 "0a3201a05f93f18c840f3e9970d33f756a621eea719cbdfa24a514f96c79de7e"
  end

  resource "fqdn" do
    url "https://files.pythonhosted.org/packages/30/3e/a80a8c077fd798951169626cde3e239adeba7dab75deb3555716415bd9b0/fqdn-1.5.1.tar.gz"
    sha256 "105ed3677e767fb5ca086a0c1f4bb66ebc3c100be518f0e0d755d9eae164d89f"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/05/b1/efac073e0c297ecf2fb33c346989a529d4e19164f1759102dee5953ee17e/idna-3.14.tar.gz"
    sha256 "466d810d7a2cc1022bea9b037c39728d51ae7dad40d480fc9b7d7ecf98ba8ee3"
  end

  resource "isoduration" do
    url "https://files.pythonhosted.org/packages/7c/1a/3c8edc664e06e6bd06cce40c6b22da5f1429aa4224d0c590f3be21c91ead/isoduration-20.11.0.tar.gz"
    sha256 "ac2f9015137935279eac671f94f89eb00584f940f5dc49462a0c4ee692ba1bd9"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/18/c7/af399a2e7a67fd18d63c40c5e62d3af4e67b836a2107468b6a5ea24c4304/jsonpointer-3.1.1.tar.gz"
    sha256 "0b801c7db33a904024f6004d526dcc53bbb8a4a0f4e32bfd10beadf60adf1900"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/b3/fc/e067678238fa451312d4c62bf6e6cf5ec56375422aee02f9cb5f909b3047/jsonschema-4.26.0.tar.gz"
    sha256 "0c26707e2efad8aa1bfc5b7ce170f3fccc2e4918ff85989ba9ffa9facb2be326"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/19/74/a633ee74eb36c44aa6d1095e7cc5569bebf04342ee146178e2d36600708b/jsonschema_specifications-2025.9.1.tar.gz"
    sha256 "b540987f239e745613c7a9176f3edb72b832a4ac465cf02712288397832b5e8d"
  end

  resource "lark" do
    url "https://files.pythonhosted.org/packages/da/34/28fff3ab31ccff1fd4f6c7c7b0ceb2b6968d8ea4950663eadcb5720591a0/lark-1.3.1.tar.gz"
    sha256 "b426a7a6d6d53189d318f2b6236ab5d6429eaf09259f1ca33eb716eed10d2905"
  end

  resource "license-expression" do
    url "https://files.pythonhosted.org/packages/40/71/d89bb0e71b1415453980fd32315f2a037aad9f7f70f695c7cec7035feb13/license_expression-30.4.4.tar.gz"
    sha256 "73448f0aacd8d0808895bdc4b2c8e01a8d67646e4188f887375398c761f340fd"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/28/30/9abc9e34c657c33834eaf6cd02124c61bdf5944d802aa48e69be8da3585d/lxml-6.1.0.tar.gz"
    sha256 "bfd57d8008c4965709a919c3e9a98f76c2c7cb319086b3d26858250620023b13"
  end

  resource "packageurl-python" do
    url "https://files.pythonhosted.org/packages/f5/d6/3b5a4e3cfaef7a53869a26ceb034d1ff5e5c27c814ce77260a96d50ab7bb/packageurl_python-0.17.6.tar.gz"
    sha256 "1252ce3a102372ca6f86eb968e16f9014c4ba511c5c37d95a7f023e2ca6e5c25"
  end

  resource "ply" do
    url "https://files.pythonhosted.org/packages/e5/69/882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4da/ply-3.11.tar.gz"
    sha256 "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3"
  end

  resource "py-serializable" do
    url "https://files.pythonhosted.org/packages/73/21/d250cfca8ff30c2e5a7447bc13861541126ce9bd4426cd5d0c9f08b5547d/py_serializable-2.1.0.tar.gz"
    sha256 "9d5db56154a867a9b897c0163b33a793c804c80cee984116d02d49e4578fc103"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/f3/91/9c6ee907786a473bf81c5f53cf703ba0957b23ab84c264080fb5a450416f/pyparsing-3.3.2.tar.gz"
    sha256 "c777f4d763f140633dcb6d8a3eda953bf7a214dc4eff598413c070bcdc117cbc"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "rdflib" do
    url "https://files.pythonhosted.org/packages/98/f5/18bb77b7af9526add0c727a3b2048959847dc5fb030913e2918bf384fec3/rdflib-7.6.0.tar.gz"
    sha256 "6c831288d5e4a5a7ece85d0ccde9877d512a3d0f02d7c06455d00d6d0ea379df"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/22/f5/df4e9027acead3ecc63e50fe1e36aca1523e1719559c499951bb4b53188f/referencing-0.37.0.tar.gz"
    sha256 "44aefc3142c5b842538163acb373e24cce6632bd54bdb01b21ad5863489f50d8"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/43/b8/7a707d60fea4c49094e40262cc0e2ca6c768cca21587e34d3f705afec47e/requests-2.34.0.tar.gz"
    sha256 "7d62fe92f50eb82c529b0916bb445afa1531a566fc8f35ffdc64446e771b856a"
  end

  resource "rfc3339-validator" do
    url "https://files.pythonhosted.org/packages/28/ea/a9387748e2d111c3c2b275ba970b735e04e15cdb1eb30693b6b5708c4dbd/rfc3339_validator-0.1.4.tar.gz"
    sha256 "138a2abdf93304ad60530167e51d2dfb9549521a836871b88d7f4695d0022f6b"
  end

  resource "rfc3986-validator" do
    url "https://files.pythonhosted.org/packages/da/88/f270de456dd7d11dcc808abfa291ecdd3f45ff44e3b549ffa01b126464d0/rfc3986_validator-0.1.1.tar.gz"
    sha256 "3d44bde7921b3b9ec3ae4e3adca370438eccebc676456449b145d533b240d055"
  end

  resource "rfc3987-syntax" do
    url "https://files.pythonhosted.org/packages/2c/06/37c1a5557acf449e8e406a830a05bf885ac47d33270aec454ef78675008d/rfc3987_syntax-1.1.0.tar.gz"
    sha256 "717a62cbf33cffdd16dfa3a497d81ce48a660ea691b1ddd7be710c22f00b4a0d"
  end

  resource "semantic-version" do
    url "https://files.pythonhosted.org/packages/7d/31/f2289ce78b9b473d582568c234e104d2a342fd658cc288a7553d83bb8595/semantic_version-2.10.0.tar.gz"
    sha256 "bdabb6d336998cbb378d4b9db3a4b56a1e3235701dc05ea2690d9a997ed5041c"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "sortedcontainers" do
    url "https://files.pythonhosted.org/packages/e8/c4/ba2f8066cceb6f23394729afe52f3bf7adec04bf9ed2c820b39e19299111/sortedcontainers-2.4.0.tar.gz"
    sha256 "25caa5a06cc30b6b83d11423433f65d1f9d76c4c6a0c90e3379eaa43b9bfdb88"
  end

  resource "spdx-tools" do
    url "https://files.pythonhosted.org/packages/2f/99/33383f587b59cbd191cc1c0fd5408e550b9275e0090d32561cbddc973fdc/spdx_tools-0.8.5.tar.gz"
    sha256 "be600beb2f762f0116025e05490d399e724f668bef84025a7c421bb266688bdb"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/46/58/8c37dea7bbf769b20d58e7ace7e5edfe65b849442b00ffcdd56be88697c6/tabulate-0.10.0.tar.gz"
    sha256 "e2cfde8f79420f6deeffdeda9aaec3b6bc5abce947655d17ac662b126e48a60d"
  end

  resource "tomli-w" do
    url "https://files.pythonhosted.org/packages/19/75/241269d1da26b624c0d5e110e8149093c759b7a286138f4efd61a60e75fe/tomli_w-1.2.0.tar.gz"
    sha256 "2dd14fac5a47c27be9cd4c976af5a12d87fb1f0b4512f81d69cce3b35ae25021"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/ba/19/1b9b0e29f30c6d35cb345486df41110984ea67ae69dddbc0e8a100999493/tzdata-2026.2.tar.gz"
    sha256 "9173fde7d80d9018e02a662e168e5a2d04f87c41ea174b139fbef642eda62d10"
  end

  resource "uri-template" do
    url "https://files.pythonhosted.org/packages/31/c7/0336f2bd0bcbada6ccef7aaa25e443c118a704f828a0620c6fa0207c1b64/uri-template-1.3.0.tar.gz"
    sha256 "0e00f8eb65e18c7de20d595a14336e9f337ead580c70934141624b6d1ffdacc7"
  end

  resource "uritools" do
    url "https://files.pythonhosted.org/packages/8a/97/508fa009ddc9c0d0e6e687eca0e3aa6ff09ac9836f98c28958a7eed936c1/uritools-6.1.0.tar.gz"
    sha256 "be97e452528e7a42ef0a4df68364ddd77833e982c5bac5cdcfee15c81f65e96b"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  resource "wcmatch" do
    url "https://files.pythonhosted.org/packages/79/3e/c0bdc27cf06f4e47680bd5803a07cb3dfd17de84cde92dd217dcb9e05253/wcmatch-10.1.tar.gz"
    sha256 "f11f94208c8c8484a16f4f48638a85d771d9513f4ab3f37595978801cb9465af"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/2c/ee/afaf0f85a9a18fe47a67f1e4422ed6cf1fe642f0ae0a2f81166231303c52/wcwidth-0.7.0.tar.gz"
    sha256 "90e3a7ea092341c44b99562e75d09e4d5160fe7a3974c6fb842a101a95e7eed0"
  end

  resource "webcolors" do
    url "https://files.pythonhosted.org/packages/1d/7a/eb316761ec35664ea5174709a68bbd3389de60d4a1ebab8808bfc264ed67/webcolors-25.10.0.tar.gz"
    sha256 "62abae86504f66d0f6364c2a8520de4a0c47b80c03fc3a5f1815fedbef7c19bf"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/19/70/80f3b7c10d2630aa66414bf23d210386700aa390547278c789afa994fd7e/xmltodict-1.0.4.tar.gz"
    sha256 "6d94c9f834dd9e44514162799d344d815a3a4faec913717a9ecbfa5be1bb8e61"
  end

  def install
    rewrite_shebang detected_python_shebang, "meta_package_manager/bar_plugin.py"
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"mpm", shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mpm --version")

    # Check mpm is detecting brew and report it as a manager in a table row.
    assert_match "brew,Homebrew Formulae,✓,✓",
      shell_output("#{bin}/mpm --table-format csv --all-managers managers")
    # Check mpm is reporting itself as installed via brew in a table row.
    assert_match "meta-package-manager,,brew,#{version}", shell_output("#{bin}/mpm --table-format csv installed")
  end
end
