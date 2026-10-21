class Molecule < Formula
  include Language::Python::Virtualenv

  desc "Automated testing for Ansible roles"
  homepage "https://docs.ansible.com/projects/molecule/"
  url "https://files.pythonhosted.org/packages/ea/86/6f3b9af840bea4296746db9ebfe6809f7848bb68e0dac7ac639879b72d6a/molecule-26.10.0.tar.gz"
  sha256 "32533aaba78c29eed80bcaab5d03ff63fe48b8f43071cf77953f391e0732d439"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "8c21b28e561a637d125af77a2380048794ba9df747627d16ef51ae3141b168c6"
    sha256 cellar: :any, arm64_tahoe:       "7e6f9d71639fb433587c8f5a93960b1bd61a049ab02c3197108ecd5c19c82c6d"
    sha256 cellar: :any, arm64_sequoia:     "067d19bc8be220401cb1fd21835c9c90c48dbeaea21b146d158713a7ac9c782e"
    sha256 cellar: :any, arm64_linux:       "ad5aec7377389bbe6b8497ca36e1bd09d8b94f21d5a64435fde8b0ffa51b088a"
    sha256 cellar: :any, x86_64_linux:      "df237a455c558c1f421c01eaffe370b0fa0715e1a3e78d27895d1d9e6080b792"
  end

  depends_on "ansible"
  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.14"
  depends_on "rpds-py" => :no_linkage

  uses_from_macos "libffi"

  on_linux do
    depends_on "gmp"
  end

  pypi_packages exclude_packages: %w[certifi cryptography rpds-py],
                extra_packages:   %w[distro molecule-plugins[azure,docker,ec2,gce,podman,vagrant,openstack] selinux]

  resource "ansible-compat" do
    url "https://files.pythonhosted.org/packages/44/f9/2074324a0c404e5f7d547fdaaa93042a792c66e2031ba02c972df67aed22/ansible_compat-26.10.0.tar.gz"
    sha256 "b0fcc0b9585611045b4b91268d3b4337c9159ae0dc550b69a553a33af48af826"
  end

  resource "ansible-core" do
    url "https://files.pythonhosted.org/packages/0b/27/d02c3f75e9f1468b5efbe49667574f68331b17e8a9f2bb99e1d18be70052/ansible_core-2.21.5.tar.gz"
    sha256 "65bb3148c58ebb843cd5074004c805f404f152114d98476dd823324616c9c6cb"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "bracex" do
    url "https://files.pythonhosted.org/packages/e1/60/e2a6409041cb3f8ce7ac3d6917b5b30c39f81a0a5b2d414ec30f36fd96bf/bracex-3.1.tar.gz"
    sha256 "35c69fc105f08d77c02722e8ae707c656ff298dd4d26c89bcb3c98fca8bc3614"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/33/1c/f41d4e74c28ab327ff3acd36053f7ea506c55872d7a90b0fa71aa3ab0c89/charset_normalizer-3.5.2.tar.gz"
    sha256 "39de2a259fc954455c57274dc94c79d5842774e1247a016aff30bc0efed0f4ef"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/60/8b/32f9823da46cde7df2087faa08cd98d01b908f8dcab982cdba9c84e85355/decorator-5.3.1.tar.gz"
    sha256 "4cbcdd55a6efadb9dbea26b858f4fb3264567b52d69ca0d25b721b553f60ea82"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/fc/f8/98eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3/distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "docker" do
    url "https://files.pythonhosted.org/packages/88/7f/731ff914b0255d3d065f45fd4e626d4b8c95dbcbaada049f337a6ac16410/docker-7.2.0.tar.gz"
    sha256 "cebb93773d334f778e023a7ee352a8d6e13ab1bd3b863a4d4a59dec897df43ac"
  end

  resource "dogpile-cache" do
    url "https://files.pythonhosted.org/packages/e7/c8/301ff89746e76745b937606df4753c032787c59ecb37dd4d4250bddc8929/dogpile_cache-1.5.0.tar.gz"
    sha256 "849c5573c9a38f155cd4173103c702b637ede0361c12e864876877d0cd125eec"
  end

  resource "enrich" do
    url "https://files.pythonhosted.org/packages/bb/77/cb9b3d6f2e2e5f8104e907ea4c4d575267238f52c51cf9f864b865a99710/enrich-1.2.7.tar.gz"
    sha256 "0a2ab0d2931dff8947012602d1234d2a3ee002d9a355b5d70be6bf5466008893"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/c7/0b/9788e913f2202da49068c27ce821eebcf96319240a89d7bb11f206d6471f/google_auth-2.61.0.tar.gz"
    sha256 "37f0815967322e8c32b12bf422531e8b637cafdaae0acbb9141117cfe6a96f23"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "iso8601" do
    url "https://files.pythonhosted.org/packages/b9/f3/ef59cee614d5e0accf6fd0cbba025b93b272e626ca89fb70a3e9187c5d15/iso8601-2.1.0.tar.gz"
    sha256 "6b1d3829ee8921c4301998c909f7829fa9ed3cbdac0d3b16af2d743aed1ba8df"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/d3/59/322338183ecda247fb5d1763a6cbe46eff7222eaeebafd9fa65d4bf5cb11/jmespath-1.1.0.tar.gz"
    sha256 "472c87d80f36026ae83c6ddd0f1d05d4e510134ed462851fd5f754c8c3cbb88d"
  end

  resource "jsonpatch" do
    url "https://files.pythonhosted.org/packages/df/f8/48a6033ebdd5013a58b5a79402eacb15ffb6e208f244c1c17f6f1e3b29c2/jsonpatch-1.35.tar.gz"
    sha256 "679ad08672b4663c7ef1e5f3331d940f5e7786661b9acc1530104be1638e7a4f"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/33/a2/c92f0a7ed439c490d2c8ad712fdb074c311afa4f77870987826a3b1483ba/jsonpointer-3.2.1.tar.gz"
    sha256 "47c846513b3a4ec46eecef1105207fba075e2a3659048e362bd7daff0fc33342"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/b3/fc/e067678238fa451312d4c62bf6e6cf5ec56375422aee02f9cb5f909b3047/jsonschema-4.26.0.tar.gz"
    sha256 "0c26707e2efad8aa1bfc5b7ce170f3fccc2e4918ff85989ba9ffa9facb2be326"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/19/74/a633ee74eb36c44aa6d1095e7cc5569bebf04342ee146178e2d36600708b/jsonschema_specifications-2025.9.1.tar.gz"
    sha256 "b540987f239e745613c7a9176f3edb72b832a4ac465cf02712288397832b5e8d"
  end

  resource "keystoneauth1" do
    url "https://files.pythonhosted.org/packages/04/af/268e14554c6bd4a2614872fb2b8431e466ce01415a9783b260ce7fb7ae5c/keystoneauth1-5.18.1.tar.gz"
    sha256 "8970f9d103f335c39151366d70c001d1bb99b00d73845f03d47825e8dc35ff78"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/38/9b/e422a865e1d5d57d0e509b4e0bf1c1a70a7f6382c29a5aa428df994c8bc8/markupsafe-3.0.4.tar.gz"
    sha256 "2e9ad7dd851bf45fab9f75cbff4cb493fee9979e8d8c7c9c3ee119022518edd6"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "molecule-plugins" do
    url "https://files.pythonhosted.org/packages/28/56/ad3cdeccce8329532f1bdee1ddfce5c01eda24a454e2ca3b4b74f2ef6bba/molecule_plugins-26.9.28.tar.gz"
    sha256 "bef4549c2a9d342c206cea4b6733c67282346b628cfce8d9a1500a9de0f8fc15"
  end

  resource "openstacksdk" do
    url "https://files.pythonhosted.org/packages/c0/c6/2deaf1bf7a44614d49daf343c2cab7d41268bb053995096fe9db1594ceed/openstacksdk-4.21.0.tar.gz"
    sha256 "8890c6ff4a41cbfef1ccbac810c16f11877d9430d9724d999921e5ef557c4daf"
  end

  resource "os-service-types" do
    url "https://files.pythonhosted.org/packages/86/ae/fe7ac23155ae0b4b9779e06e9c5bb4070f2315dc4ca886a88fa3230d344b/os_service_types-1.9.0.tar.gz"
    sha256 "1f2e5fb71d1f6f4ff31d8992674f2368465bc2f25cd94018015c3ddbfc5c617f"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/6b/8d/ce438c28c7958e33184e8ac851ea2225b47a41e5e9e708fa3bddba631135/pbr-7.1.3.tar.gz"
    sha256 "9a4a85b84e906337708009af0b5f5cdabeeb72d4dc213c9e97974da54fd9acc5"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/80/a8/66d45abadff219e36e2a824181b8f6a67e7ed4572934d6252c71c29d5731/platformdirs-4.13.0.tar.gz"
    sha256 "1aa0b0d3f224c1f07c295121e312a5a24a180d6ae5a8425ea1784b3e3863e9c0"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/aa/c6/d1ddf4abb55e93cebc4f2ed8b5d6dbad109ecb8d63748dd2b20ab5e57ebe/psutil-7.2.2.tar.gz"
    sha256 "0746f5f8d406af344fd547f1c8daa5f5c33dbc293bb8d6a16d80b4bb88f59372"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/a4/9a/23310166d960def5897e91fe20e5b724601b02a22e84ba1f94232c0b7f67/pyasn1-0.6.4.tar.gz"
    sha256 "9c447d8431c947fe4c8febc4ed9e760bc29011a5b01e5c74b67025bd9fb8ce81"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/e9/e6/78ebbb10a8c8e4b61a59249394a4a594c1a7af95593dc933a349c8d00964/pyasn1_modules-0.4.2.tar.gz"
    sha256 "677091de870a80aae844b1ca6134f54652fa2c8c5a52aa396440ac3106e941e6"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "python-vagrant" do
    url "https://files.pythonhosted.org/packages/2b/3f/2e42a44c9705d72d9925fe8daf00f31bcf82e8b84ec5a752a8a1357c3ef8/python-vagrant-1.0.0.tar.gz"
    sha256 "a8fe93ccf2ff37ecc95ec2f49ea74a91a6ce73a4db4a16a98dd26d397cfd09e5"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/22/f5/df4e9027acead3ecc63e50fe1e36aca1523e1719559c499951bb4b53188f/referencing-0.37.0.tar.gz"
    sha256 "44aefc3142c5b842538163acb373e24cce6632bd54bdb01b21ad5863489f50d8"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "resolvelib" do
    url "https://files.pythonhosted.org/packages/1d/14/4669927e06631070edb968c78fdb6ce8992e27c9ab2cde4b3993e22ac7af/resolvelib-1.2.1.tar.gz"
    sha256 "7d08a2022f6e16ce405d60b68c390f054efcfd0477d4b9bd019cc941c28fad1c"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "selinux" do
    url "https://files.pythonhosted.org/packages/25/07/51acd62e1e15e1172d46f7e32faf138725b147f8c08dbf2d512159d7a310/selinux-0.3.0.tar.gz"
    sha256 "2a88b337ac46ad0f06f557b2806c3df62421972f766673dd8bf26732fb75a9ea"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/6d/44/f5da03a8ef95d369145c5bb53050e7877c9f3d312e128605fd9504829143/setuptools-84.0.0.tar.gz"
    sha256 "f4695c21257f0d9b537ec2692c941d02ee143b7cc1276941349a546573b2ef73"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/db/a1/3b8ed9c1fc3aa6eebb57732d924ddaa0500ecc3b638d0454816320994383/stevedore-5.9.1.tar.gz"
    sha256 "e97a2667923efda926e8713fde6a73616df68210a3cbc6f02b48967b676fd8bf"
  end

  resource "subprocess-tee" do
    url "https://files.pythonhosted.org/packages/d7/22/991efbf35bc811dfe7edcd749253f0931d2d4838cf55176132633e1c82a7/subprocess_tee-0.4.2.tar.gz"
    sha256 "91b2b4da3aae9a7088d84acaf2ea0abee3f4fd9c0d2eae69a9b9122a71476590"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  resource "wcmatch" do
    url "https://files.pythonhosted.org/packages/78/cd/0e028d8b7d906d51acdac537334fbe85f8284f2a8147d48bc9403af77a0d/wcmatch-11.1.tar.gz"
    sha256 "f2b6f0fad6f5e2571498723fcb3c8facdd0fba0dcc139f31d32f592eb648153e"
  end

  def install
    without = ["enrich", "python-vagrant"]
    without += ["distro", "selinux"] unless OS.linux?
    venv = virtualenv_install_with_resources(without:)

    # Drop `pkg_resources`-based build dep, https://github.com/pycontribs/enrich/pull/45
    resource("enrich").stage do
      inreplace "pyproject.toml", /^\s*"setuptools_scm_git_archive.*\n/, ""
      inreplace "setup.cfg", /^\s*setuptools_scm_git_archive.*\n/, ""
      venv.pip_install Pathname.pwd
    end

    # Drop `pkg_resources`-based build dep, https://github.com/pycontribs/python-vagrant/commit/46a6c3ca4922711162fafd4a7d89f31030cac056
    resource("python-vagrant").stage do
      inreplace "pyproject.toml", /^\s*"setuptools_scm_git_archive.*\n/, ""
      venv.pip_install Pathname.pwd
    end

    generate_completions_from_executable(bin/"molecule", shell_parameter_format: :click)
  end

  test do
    ENV["ANSIBLE_REMOTE_TMP"] = testpath/"tmp"
    ENV["ANSIBLE_PYTHON_INTERPRETER"] = python3

    system bin/"molecule", "init", "scenario", "acme.foo_vagrant"
    assert_path_exists testpath/"molecule/acme.foo_vagrant/molecule.yml",
                       "Failed to create 'molecule/acme.foo_vagrant/molecule.yml' file!"
    output = shell_output("#{bin}/molecule list --format yaml 2>&1")
    assert_match "INFO     [acme.foo_vagrant > list] Executed: Successful", output
  end
end
