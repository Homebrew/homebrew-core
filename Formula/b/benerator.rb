class Benerator < Formula
  desc "Tool for realistic test data generation"
  homepage "https://rapiddweller.github.io/homebrew-benerator/"
  url "https://github.com/rapiddweller/rapiddweller-benerator-ce/releases/download/3.2.1/rapiddweller-benerator-ce-3.2.1-jdk-11-dist.tar.gz"
  sha256 "5d1b3de2344f0c2a1719eed5ab8154a75597a5d7693c373734e0603a45e5f96d"
  license "Apache-2.0"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "a73bf659d5c7c62f8048aae669bd74c7da97f750ce0ecb1d8009f94ba32e77fd"
  end

  depends_on "openjdk@11"

  def install
    # Remove unnecessary files
    rm(Dir["bin/*.bat", "bin/pom.xml"])

    # Installs only the "bin" and "lib" directories from the tarball
    libexec.install Dir["bin", "lib"]
    # Generate a script that sets the necessary environment variables
    env = Language::Java.overridable_java_home_env("11")
    env["BENERATOR_HOME"] = libexec
    (bin/"benerator").write_env_script(libexec/"bin/benerator", env)
  end

  test do
    # Test if version is correct
    assert_match "Benerator Community Edition #{version}-jdk-11",
                 shell_output("#{bin}/benerator --version")
    assert_match "Java version:  #{Formula["openjdk@11"].version}", shell_output("#{bin}/benerator --version")
    # Test if data is generated follow the corrected scheme.
    # We feed benerator an xml and a scheme in demo/db/script/h2.multischema.sql.
    # The XML scheme in myscript.xml have an inhouse test in <evaluate /> to check if the data is generated correctly,
    # If no, benerator will throw an error, otherwise a success message will be printed.
    (testpath/"myscript.xml").write <<~XML
      <setup defaultDataset="US" defaultLocale="en_US">
      <import domains="person,net,product"/>
      <import platforms="db"/>

      <comment>setting default values</comment>
      <setting name="stage" default="development"/>
      <setting name="database" default="h2"/>
      <setting name="dbUrl" default="jdbc:h2:mem:benerator"/>
      <setting name="dbDriver" default="org.h2.Driver"/>
      <setting name="dbSchema" default="public"/>
      <setting name="dbUser" default="sa"/>

      <comment>log the settings to the console</comment>
      <echo>{ftl:encoding:${context.defaultEncoding} default pageSize:${context.defaultPageSize}}</echo>
      <echo>{ftl:JDBC URL: ${dbUrl}}</echo>

      <comment>define a database that will be referred by the id 'db' subsequently</comment>
      <database id="db"
      url="{dbUrl}"
      driver="{dbDriver}"
      schema="{dbSchema}"
      user="{dbUser}"
      />

      <execute type="sql" target="db" uri="demo/db/script/h2.multischema.sql"/>

      <database id="schema1" url="{dbUrl}" driver="{dbDriver}" schema="schema1"
      user="{dbUser}"/>
      <database id="schema3" url="{dbUrl}" driver="{dbDriver}" schema="schema3"
      user="{dbUser}"/>

      <generate type="db_manufacturer" count="100" consumer="schema3">
      <id name="id" generator="IncrementGenerator"/>
      <attribute name="name" pattern="[A-Z][A-Z]{5,12}"/>
      </generate>
      <generate type="db_Category" count="10" consumer="schema1">
      <id name="id" generator="IncrementGenerator"/>
      </generate>
      <generate type="db_product" count="100" consumer="schema1">
      <id name="ean_code" generator="EANGenerator"/>
      <attribute name="price" pattern="[1-9]{1,2}"/>
      <attribute name="name" pattern="[A-Z][A-Z]{5,12}"/>
      <attribute name="notes" pattern="[A-Z][\n][a-z][0-9]{1,256}"/>
      <attribute name="description" pattern="[A-Z][\n][a-z][0-9]{1,256}"/>
      <reference name="manufacturer_id" source="schema3" targetType="db_manufacturer"/>
      </generate>

      <echo>Printing all generated data</echo>
      <iterate name="CAT_TRANS" type="db_Category" source="schema1" consumer="ConsoleExporter"/>
      <iterate name="PROD_TRANS" type="db_product" source="schema1" consumer="ConsoleExporter"/>
      <iterate name="MAN_TRANS" type="db_manufacturer" source="schema3" consumer="ConsoleExporter"/>

      <echo>Verifying generated data</echo>
      <evaluate assert="result == 10" target="schema1">select count(*) from "schema1"."db_Category"</evaluate>
      <evaluate assert="result == 100" target="schema1">select count(*) from "schema1"."db_product"</evaluate>
      <evaluate assert="result == 100" target="schema3">select count(*) from "schema3"."db_manufacturer"</evaluate>
      <echo>No Error Occurs. Data Generated Correctly</echo>
      </setup>
    XML

    assert_match "No Error Occurs. Data Generated Correctly",
      shell_output("#{bin}/benerator myscript.xml")
  end
end
