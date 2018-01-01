class AppscaleTools < Formula
  desc "Command-line tools for working with AppScale"
  homepage "https://github.com/AppScale/appscale-tools"
  url "https://github.com/AppScale/appscale-tools/archive/3.4.0.tar.gz"
  sha256 "0e38f4fed78cd2bc54aa1a3694004377a8b7c2802a0d37a8400c092baa09ba06"
  head "https://github.com/AppScale/appscale-tools.git"

  bottle do
    cellar :any
    sha256 "3d01928c4c18a23c99f5c0a6fbbabba2681f387d3bc50be0dd83f7e15ec3fe9f" => :high_sierra
    sha256 "354e148a73db62d91e8b0cfd5208689b6821cba69470f6db8ffd8a58f23b7f52" => :sierra
    sha256 "956eb986a67094be2c35756c948bc291729c746903ff62b419b9f2649bdc7ecb" => :el_capitan
  end

  depends_on "python" if MacOS.version <= :snow_leopard
  depends_on "libyaml"
  depends_on "ssh-copy-id"
  depends_on "openssl"

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/8a/48/a76be51647d0eb9f10e2a4511bf3ffb8cc1e6b14e9e4fab46173aa79f981/termcolor-1.1.0.tar.gz"
    sha256 "1d6d69ce66211143803fbc56652b41d73b4a400a2891d7bf7a1cdf4c02de613b"
  end

  resource "SOAPpy" do
    url "https://files.pythonhosted.org/packages/78/1b/29cbe26b2b98804d65e934925ced9810883bdda9eacba3f993ad60bfe271/SOAPpy-0.12.22.zip"
    sha256 "e70845906bb625144ae6a8df4534d66d84431ff8e21835d7b401ec6d8eb447a5"
  end

  # Dependencies for SOAPpy
  resource "docutils" do
    url "https://files.pythonhosted.org/packages/05/25/7b5484aca5d46915493f1fd4ecb63c38c333bd32aa9ad6e19da8d08895ae/docutils-0.13.1.tar.gz"
    sha256 "718c0f5fb677be0f34b781e04241c4067cbd9327b66bdd8e763201130f5175be"
  end

  resource "wstools" do
    url "https://files.pythonhosted.org/packages/81/a3/0fbea78bccec0970032b847135b0d6050224c8601460464edcc748c5a22c/wstools-0.4.3.tar.gz"
    sha256 "578b53e98bc8dadf5a55dfd1f559fd9b37a594609f1883f23e8646d2d30336f8"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/74/ba/4ba4e89e21b5a2e267d80736ea674609a0a33cc4435a6d748ef04f1f9374/defusedxml-0.5.0.tar.gz"
    sha256 "24d7f2f94f7f3cb6061acb215685e5125fbcdc40a857eff9de22518820b0a4f4"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/4a/85/db5a2df477072b2902b0eb892feb37d88ac635d36245a72a6a69b23b383a/PyYAML-3.12.tar.gz"
    sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"
  end

  resource "boto" do
    url "https://files.pythonhosted.org/packages/b1/f9/cf8fa9a4a48e651294fc88446edee96f8b965f1d3ca044befc5dd7c9449b/boto-2.46.1.tar.gz"
    sha256 "d24a68d97276445d1b5baee6537bc565ab7070afcd449a72f2541b1da1328ed4"
  end

  resource "argparse" do
    url "https://files.pythonhosted.org/packages/18/dd/e617cfc3f6210ae183374cd9f6a26b20514bbb5a792af97949c5aacddf0f/argparse-1.4.0.tar.gz"
    sha256 "62b089a55be1d8949cd2bc7e0df0bddb9e028faefc8c32038cc84862aefdd6e4"
  end

  resource "google-api-python-client" do
    url "https://files.pythonhosted.org/packages/31/c4/c77f3ddadf17d041f237615d5fba02faefd93adfb82ad75877156647491a/google-api-python-client-1.5.4.tar.gz"
    sha256 "b9f6697cf9d2d556e8241c18518f1f9a2531e71b59703d0d1505bb47e97009ac"
  end

  resource "uritemplate" do
    url "https://files.pythonhosted.org/packages/cd/db/f7b98cdc3f81513fb25d3cbe2501d621882ee81150b745cdd1363278c10a/uritemplate-3.0.0.tar.gz"
    sha256 "c02643cebe23fc8adb5e6becffe201185bf06c40bda5c0b4028a93f1527d011d"
  end

  # Dependencies for google-api-python-client
  resource "oauth2client" do
    url "https://files.pythonhosted.org/packages/c2/ce/7aaf19d8b856191e2e1885201fe45f3dc57b97f5ec5bc98ef2cc15472918/oauth2client-4.0.0.tar.gz"
    sha256 "80be5420889694634b8517b4acd3292ace881d9d1aa9d590d37ec52faec238c7"
  end

  # Dependencies for oauth2client
  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/69/17/eec927b7604d2663fef82204578a0056e11e0fc08d485fdb3b6199d9b590/pyasn1-0.2.3.tar.gz"
    sha256 "738c4ebd88a718e700ee35c8d129acce2286542daa80a82823a7073644f706ad"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/60/32/7703bccdba05998e4ff04db5038a6695a93bedc45dcf491724b85b5db76a/pyasn1-modules-0.0.8.tar.gz"
    sha256 "10561934f1829bcc455c7ecdcdacdb4be5ffd3696f26f468eb6eb41e107f3837"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/14/89/adf8b72371e37f3ca69c6cb8ab6319d009c4a24b04a31399e5bd77d9bb57/rsa-3.4.2.tar.gz"
    sha256 "25df4e10c263fb88b5ace923dd84bf9aa7f5019687b5e55382ffcdb8bede9db5"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/e4/2e/a7e27d2c36076efeb8c0e519758968b20389adf57a9ce3af139891af2696/httplib2-0.10.3.tar.gz"
    sha256 "e404d3b7bd86c1bc931906098e7c1305d6a3a6dcef141b8bb1059903abb3ceeb"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/1c/a1/3367581782ce79b727954f7aa5d29e6a439dc2490a9ac0e7ea0a7115435d/tabulate-0.7.7.tar.gz"
    sha256 "83a0b8e17c09f012090a50e1e97ae897300a72b35e0c86c0b53d3bd2ae86d8c6"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/dc/8c/7c9869454bdc53e72fb87ace63eac39336879eef6f2bf96e946edbf03e90/setuptools-33.1.1.zip"
    sha256 "6b20352ed60ba08c43b3611bdb502286f7a869fbfcf472f40d7279f1e77de145"
  end

  # Dependencies for Azure
  resource "azure-mgmt-nspkg" do
    url "https://files.pythonhosted.org/packages/08/19/7de3fced806761f4f1c09899c008cae4979e3bd598105e089edeea7a502a/azure-mgmt-nspkg-1.0.0.zip"
    sha256 "b87268f1cc7c78d8c285a831c336d30fee09f8f2cda482c29cd8ee39a41309e7"
  end

  resource "azure-nspkg" do
    url "https://files.pythonhosted.org/packages/6c/bc/16e85022bef01d024cac48ad2d1bfe41279ca9a369faab30138e72d0ee1b/azure-nspkg-1.0.0.zip"
    sha256 "293f286c15ea123761f30f5b1cb5adebe5f1e5009efade923c6dd1e017621bf7"
  end

  resource "azure-common" do
    url "https://files.pythonhosted.org/packages/00/39/7b915a03e1a64415c81a8b8f317556182592327d2b62812ef2b19e71b378/azure-common-1.1.4.zip"
    sha256 "f8c8d97d0a7de202a47d7081c39c0e4a827c78900719d02c2ebe936e44ff152f"
  end

  resource "azure-servicemanagement-legacy" do
    url "https://files.pythonhosted.org/packages/71/72/247d6e15711ace1e0e680d067f34e04facb3bc4b340234c0267b54842b01/azure-servicemanagement-legacy-0.20.4.zip"
    sha256 "742df8756065ff033d9af974851d2de6df5cc09de53802cf3172646c1e7f2932"
  end

  resource "futures" do
    url "https://files.pythonhosted.org/packages/55/db/97c1ca37edab586a1ae03d6892b6633d8eaa23b23ac40c7e5bbc55423c78/futures-3.0.5.tar.gz"
    sha256 "0542525145d5afc984c88f914a0c85c77527f65946617edb5274f72406f981df"
  end

  resource "azure-storage" do
    url "https://files.pythonhosted.org/packages/94/fd/301d5d72126125b59731ad64bcfcc9bc75fcddb9bb8370a917559a693433/azure-storage-0.33.0.zip"
    sha256 "1117e15bdd699b7f44412fec06948b9161de13c0cd01bea092c7752112542c40"
  end

  resource "azure-servicebus" do
    url "https://files.pythonhosted.org/packages/38/97/a0f9a44d2c9501329338ae252794c12939e70188a41d902c2717f26f7385/azure-servicebus-0.20.3.zip"
    sha256 "442bf44d32286cdaef71f75e03bcff912a7111f281462b9c4d560f77687684f7"
  end

  resource "azure-batch" do
    url "https://files.pythonhosted.org/packages/2a/e9/6c16410251d9e65e89a8f72f6c5bcb3b8b54928a072e9481eccebd9c1cd4/azure-batch-1.0.0.zip"
    sha256 "0c863b863f9efa1ff1a30c4a8aa6d8bb6c80b334bb01de43ae863daefb982e3e"
  end

  resource "azure-mgmt-storage" do
    url "https://files.pythonhosted.org/packages/f8/d8/425dc59243cca1e907778445d68610345fda4ff341b12209d4d4bb3d1388/azure-mgmt-storage-0.30.0rc6.zip"
    sha256 "8038669aa1386e6def927accf4b0d0426a5a542fcce71fed4c5100aff9d55a65"
  end

  resource "azure-mgmt-resource" do
    url "https://files.pythonhosted.org/packages/5a/88/12b179f4473b51b671a126741b4520edbfea164bf0d683d3a0c78cec98a9/azure-mgmt-resource-0.30.0rc6.zip"
    sha256 "afc26ac7c0a468c04504e63f3d361ead4bdedc7e48fd41197779396423ed7383"
  end

  resource "azure-mgmt-batch" do
    url "https://files.pythonhosted.org/packages/14/15/315e59a9a3c7db95c9d653cec963d6dbb935a11335b5679aecf229d600f5/azure-mgmt-batch-1.0.0.zip"
    sha256 "3af7750aff8ccacaf73ec482bfa5c5c7ea57ca1fa9c51541da6564d91583e5eb"
  end

  resource "azure-mgmt-compute" do
    url "https://files.pythonhosted.org/packages/7d/b5/e85d7054f2ef45f4413e6711837d5dc3ac85ac3114cf3891e8938ecc40d5/azure-mgmt-compute-0.30.0rc6.zip"
    sha256 "01ec076790dc7ac509a753f2492e82776e9a0ae1556608fbc86d7b646f348d77"
  end

  resource "azure-mgmt-keyvault" do
    url "https://files.pythonhosted.org/packages/11/d8/bf649497dc0e589920393f6a3b9be3bec7eeea38c1f41d4476a5e828585b/azure-mgmt-keyvault-0.30.0rc6.zip"
    sha256 "c01e9a62cbce0889e5030653ecc99a9ff240dfd2858f666837a3247eb2c2a19a"
  end

  resource "azure-mgmt-logic" do
    url "https://files.pythonhosted.org/packages/9f/16/32ef7f8cae08a7d2c7bd096c5d9f3af2fd96de23d3f8db337333401d8b36/azure-mgmt-logic-1.0.0.zip"
    sha256 "12efc80bcab1a6e5f7a641e3873c7dfbd8ecbcba49f7c222cd04a26d196f6007"
  end

  resource "azure-mgmt-network" do
    url "https://files.pythonhosted.org/packages/60/54/1459f5652fe19da9689bf8642f84fe220f6307dac8ac2a62e2b9f582eaa2/azure-mgmt-network-0.30.0rc6.zip"
    sha256 "31b1849d470adf2189f47f8de84f0875b0ccbbc5de576cdbbd8500a1ef95870f"
  end

  resource "azure-mgmt-scheduler" do
    url "https://files.pythonhosted.org/packages/d2/42/4b15b354a2208e1fa43c327fd5a3215071140467624d3a14d97076988d7d/azure-mgmt-scheduler-1.0.0.zip"
    sha256 "bddf4b9ee5a27180782831a375604b2af0cff0c0cbd5e57a010cc4f0c6a322c3"
  end

  resource "azure-mgmt-redis" do
    url "https://files.pythonhosted.org/packages/47/bc/b42afac6ff6479c95d8d5a0946f0c94f818a2cecb84303482eecf0d41f40/azure-mgmt-redis-1.0.0.zip"
    sha256 "b5c1de56e66756134ede1757901d4c3ece62e7dcc16c21f4d7c3c7ca0e27dbad"
  end

  resource "azure-mgmt" do
    url "https://files.pythonhosted.org/packages/52/4a/1812c3d233e3d2e62613337552be64022dc4b231a5d51e25266cc68ddb33/azure-mgmt-0.30.0rc6.zip"
    sha256 "b3b0c187bcc51bbcd49b8254921d70a8988d733a7c822a533ec7ec762ccfb9b8"
  end

  resource "azure" do
    url "https://files.pythonhosted.org/packages/85/5c/d4a19612a2ca66966267198cd238ecc5e99e2082a41f0344733c7302ca92/azure-2.0.0rc6.zip"
    sha256 "d71fa18a2f8f3e6d56051782e00497d28414a68219b01899ba3f791bcd6bd324"
  end

  # Dependencies for cryptography
  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/be/64/1bb257ffb17d01f4a38d7ce686809a736837ad4371bcc5c42ba7a715c3ac/pycparser-2.17.tar.gz"
    sha256 "0aac31e917c24cb3357f5a4d5566f2cc91a19ca41862f6c3c22dc60a629673b6"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/5b/b9/790f8eafcdab455bcd3bd908161f802c9ce5adbf702a83aa7712fcc345b7/cffi-1.10.0.tar.gz"
    sha256 "b3b02911eb1f6ada203b0763ba924234629b51586f72a21faacc638269f4ced5"
  end

  resource "ipaddress" do
    url "https://files.pythonhosted.org/packages/4e/13/774faf38b445d0b3a844b65747175b2e0500164b7c28d78e34987a5bfe06/ipaddress-1.0.18.tar.gz"
    sha256 "5d8534c8e185f2d8a1fda1ef73f2c8f4b23264e8e30063feeb9511d492a413e1"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/c6/70/bb32913de251017e266c5114d0a645f262fb10ebc9bf6de894966d124e35/packaging-16.8.tar.gz"
    sha256 "5d50835fdf0a7edf0b55e311b7c887786504efea1177abd7e69329a8e5ea619e"
  end

  resource "asn1crypto" do
    url "https://files.pythonhosted.org/packages/67/14/5d66588868c4304f804ebaff9397255f6ec5559e46724c2496e0f26e68d6/asn1crypto-0.22.0.tar.gz"
    sha256 "cbbadd640d3165ab24b06ef25d1dca09a3441611ac15f6a6b452474fdf0aed1a"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/d8/82/28a51052215014efc07feac7330ed758702fc0581347098a81699b5281cb/idna-2.5.tar.gz"
    sha256 "3cb5ce08046c4e3a560fc02f138d0ac63e00f8ce5901a56b32ec8b7994082aab"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/ec/5f/d5bc241d06665eed93cd8d3aa7198024ce7833af7a67f6dc92df94e00588/cryptography-1.8.1.tar.gz"
    sha256 "323524312bb467565ebca7e50c8ae5e9674e544951d28a2904a50012a8828190"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/51/fc/39a3fbde6864942e8bb24c93663734b74e281b984d1b8c4f95d64b0c21f6/python-dateutil-2.6.0.tar.gz"
    sha256 "62a2f8df3d66f878373fd0072eacf4ee52194ba302e00082828e0d263b0418d2"
  end

  resource "PyJWT" do
    url "https://files.pythonhosted.org/packages/8f/10/9ce7e91d8ec9d852db6f9f2b076811d9f51ed7b0360602432d95e6ea4feb/PyJWT-1.4.2.tar.gz"
    sha256 "87a831b7a3bfa8351511961469ed0462a769724d4da48a501cb8c96d1e17f570"
  end

  resource "adal" do
    url "https://files.pythonhosted.org/packages/dd/55/fe57a0c94680f7b72bb524c085d28a0e407dcaa695ab927d1a904fdc7b6a/adal-0.4.5.tar.gz"
    sha256 "c5ddfd473fe272ae1deefcee22f99f094f9f195bcb52a8678b2e315b755fe253"
  end

  resource "ndg-httpsclient" do
    url "https://files.pythonhosted.org/packages/a2/a7/ad1c1c48e35dc7545dab1a9c5513f49d5fa3b5015627200d2be27576c2a0/ndg_httpsclient-0.4.2.tar.gz"
    sha256 "580987ef194334c50389e0d7de885fccf15605c13c6eecaabd8d6c43768eb8ac"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/0c/d6/b1fe519846a21614fa4f8233361574eddb223e0bc36b182140d916acfb3b/pyOpenSSL-16.2.0.tar.gz"
    sha256 "7779a3bbb74e79db234af6a08775568c6769b5821faecf6e2f4143edb227516e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/16/09/37b69de7c924d318e51ece1c4ceb679bf93be9d05973bb30c35babd596e2/requests-2.13.0.tar.gz"
    sha256 "5722cd09762faa01276230270ff16af7acf7c5c45d623868d9ba116f15791ce8"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/83/4a/3599cd149394faf96c4b9c548e3dc7e14c488945f1676348e1ab741d65d6/keyring-10.3.2.tar.gz"
    sha256 "f462698bc8b96ef5f9fb31d392611f416c808a8244d679fb02530b72bab01ad6"
  end

  resource "msrestazure" do
    url "https://files.pythonhosted.org/packages/04/67/8ab1713acc26d666008ec4fc62815adf6aef611a553e74d181f851a13cdf/msrestazure-0.4.7.zip"
    sha256 "2168f5954fd98016dfe72d75a44425dcc443110b284d5991736c24b133092063"
  end

  resource "enum34" do
    url "https://files.pythonhosted.org/packages/bf/3e/31d502c25302814a7c2f1d3959d2a3b3f78e509002ba91aea64993936876/enum34-1.1.6.tar.gz"
    sha256 "8ad8c4783bf61ded74527bffb48ed9b54166685e4230386a9ed9b1279e2df5b1"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/b6/fa/ca682d5ace0700008d246664e50db8d095d23750bb212c0086305450c276/certifi-2017.1.23.tar.gz"
    sha256 "81877fb7ac126e9215dfb15bfef7115fdc30e798e0013065158eed0707fd99ce"
  end

  resource "isodate" do
    url "https://files.pythonhosted.org/packages/f4/5b/fe03d46ced80639b7be9285492dc8ce069b841c0cebe5baacdd9b090b164/isodate-0.5.4.tar.gz"
    sha256 "42105c41d037246dc1987e36d96f3752ffd5c0c24834dd12e4fdbe1e79544e31"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/fa/2e/25f25e6c69d97cf921f0a8f7d520e0ef336dd3deca0142c0b634b0236a90/oauthlib-2.0.2.tar.gz"
    sha256 "b3b9b47f2a263fe249b5b48c4e25a5bce882ff20a0ac34d553ce43cff55b53ac"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/80/14/ad120c720f86c547ba8988010d5186102030591f71f7099f23921ca47fe5/requests-oauthlib-0.8.0.tar.gz"
    sha256 "883ac416757eada6d3d07054ec7092ac21c7f35cb1d2cf82faf205637081f468"
  end

  resource "msrest" do
    url "https://files.pythonhosted.org/packages/04/f5/70532d47dfa8a48be4d9d62b97a040c083307484dd5d77db2d3dec47a02d/msrest-0.4.7.zip"
    sha256 "864f8da2c35ed26ba1dae333716a65e640161497c668635518f6e241a4c58790"
  end

  resource "haikunator" do
    url "https://files.pythonhosted.org/packages/af/58/6a000ee0ec34cac5c78669359a8b1db969f1f511454a140ad3d193714ba2/haikunator-2.1.0.zip"
    sha256 "91ee3949a3a613cac037ddde0b16b17062e248376b11491436e49d5ddc75ff9b"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    site_packages = libexec/"lib/python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", site_packages
    system "python", *Language::Python.setup_install_args(libexec)

    # appscale is a namespace package
    touch site_packages/"appscale/__init__.py"

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system bin/"appscale", "help"
    system bin/"appscale", "init", "cloud"
  end
end
